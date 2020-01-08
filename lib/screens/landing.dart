import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:rxdart/rxdart.dart';

import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/group_ping.dart';
import 'package:inclusive/classes/message_list.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/screens/Register/index.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/classes/ping.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'Landing';
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  AppDataService appDataService;
  MessageService messageService;
  UserModel userProvider;
  TabController tabController;

  bool connected = false;

  @override
  void initState() {
    super.initState();
    AppDataService.checkInternet()
        .then((bool connected) => setState(() => this.connected = connected));
  }

  Widget getAppData() {
    return MultiProvider(providers: <SingleChildCloneableWidget>[
      FutureProvider<PermissionStatus>.value(
          value: appDataService.getLocationPermissions()),
      FutureProvider<List<Conversation>>.value(
          value: messageService.getConversations()),
      StreamProvider<User>.value(value: appDataService.getUser()),
    ], child: streamUserPings());
  }

  Widget streamUserPings() {
    return Consumer<User>(
        builder: (BuildContext context, User user, Widget widget) {
      if (user == null) {
        return RegisterScreen();
      }
      return StreamProvider<List<Ping>>.value(
          value: user.streamPings(),
          child: Consumer2<List<Conversation>, List<Ping>>(builder:
              (BuildContext context, List<Conversation> conversations,
                  List<Ping> pings, Widget widget) {
            if (conversations == null || pings == null) {
              return Loading();
            }
            if (conversations.isEmpty) {
              return HomeScreen();
            }
            for (final Ping ping in pings) {
              final int index = conversations.indexWhere(
                  (final Conversation conversation) =>
                      conversation.idPeer == ping.id);
              if (index == -1) {
                conversations.insert(
                    0, Conversation(ping.id, 0, pings: ping.value));
              } else {
                conversations[index].pings = ping.value;
              }
            }
            return streamConversations(conversations);
          }));
    });
  }

  Widget streamConversations(List<Conversation> conversations) {
    final List<Stream<MessageList>> messageStreams = <Stream<MessageList>>[];
    final List<Stream<Entity>> peerInfoStreams = <Stream<Entity>>[];
    final List<Stream<GroupPing>> groupPingStreams = <Stream<GroupPing>>[];

    for (final Conversation conversation in conversations) {
      messageStreams.add(conversation.streamMessageList());
      peerInfoStreams.add(conversation.streamPeerInfo());
      if (conversation.isGroup) {
        groupPingStreams.add(conversation.streamGroupPings());
      }
    }
    return MultiProvider(
        providers: <StreamProvider<dynamic>>[
          streamMessages(conversations, messageStreams),
          streamPeerInfo(conversations, peerInfoStreams),
          streamGroupPings(conversations, groupPingStreams),
        ],
        child: Consumer<List<MessageList>>(builder: (BuildContext context,
            List<MessageList> messageLists, Widget widget) {
          if (messageLists == null) {
            return Loading();
          }
          Provider.of<List<Entity>>(context);
          Provider.of<List<GroupPing>>(context);
          messageService.refreshPings(conversations);

          getGroupUsers(conversations, messageLists);
          return HomeScreen();
        }));
  }

  StreamProvider<List<MessageList>> streamMessages(
      List<Conversation> conversations,
      List<Stream<MessageList>> messageStreams) {
    return StreamProvider<List<MessageList>>.value(
        value: CombineLatestStream<MessageList, List<MessageList>>(
            messageStreams, (List<MessageList> messageList) {
      int index = 0;
      for (final Conversation conv in conversations) {
        conv.messageList = messageList[index];
        ++index;
      }
      return messageList;
    }));
  }

  StreamProvider<List<Entity>> streamPeerInfo(
      List<Conversation> conversations, List<Stream<Entity>> peerInfoStreams) {
    return StreamProvider<List<Entity>>.value(
        value: CombineLatestStream<Entity, List<Entity>>(peerInfoStreams,
            (List<Entity> peerInfo) {
      int index = 0;
      for (final Conversation conversation in conversations) {
        conversation.peerData = peerInfo[index];
        ++index;
      }
      return peerInfo;
    }));
  }

  StreamProvider<List<GroupPing>> streamGroupPings(
      List<Conversation> conversations,
      List<Stream<GroupPing>> groupPingStreams) {
    return StreamProvider<List<GroupPing>>.value(
        value: CombineLatestStream<GroupPing, List<GroupPing>>(groupPingStreams,
            (List<GroupPing> pings) {
      int index = 0;
      for (final Conversation conversation in conversations) {
        if (conversation.isGroup) {
          conversation.pings = pings[index].value;
          ++index;
        }
      }
      return pings;
    }));
  }

  Future<List<Conversation>> getGroupUsers(
      List<Conversation> conversations, List<MessageList> messageLists) async {
    int index = 0;
    for (final Conversation conversation in conversations) {
      if (conversation.isGroup) {
        final List<Message> messages = messageLists[index].messages;
        final List<String> ids = messages
            .map<String>((Message message) => message.idFrom)
            .toSet()
            .toList();
        List<User> users =
            await Future.wait(ids.map((String id) => userProvider.getUser(id)));
        users = List<User>.from(users);
        users.removeWhere((User user) => user == null);

        for (final Message mess in conversation.messageList.messages) {
          final int index =
              users.indexWhere((User user) => user.id == mess.idFrom);
          mess.author = index == -1 ? null : users[index];
        }
      }

      ++index;
    }
    return conversations;
  }

  @override
  Widget build(BuildContext context) {
    appDataService = Provider.of<AppDataService>(context);
    messageService = Provider.of<MessageService>(context);
    userProvider = Provider.of<UserModel>(context);

    if (!connected) {
      return Loading();
    }

    return FutureBuilder<User>(
        future: appDataService.getUser().first,
        builder: (BuildContext context, AsyncSnapshot<User> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          return getAppData();
        });
  }
}
