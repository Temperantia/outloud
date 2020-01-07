import 'package:flutter/material.dart';
import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/screens/Register/index.dart';

import 'package:inclusive/screens/home.dart';
import 'package:inclusive/screens/loading.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/services/message.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/classes/ping.dart';

import 'package:location_permissions/location_permissions.dart';

import 'package:rxdart/rxdart.dart';

class LandingScreen extends StatefulWidget {
  static final String id = 'Landing';
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
        .then((connected) => setState(() => this.connected = connected));
  }

  Widget getAppData() {
    return MultiProvider(providers: [
      FutureProvider<PermissionStatus>.value(
          value: appDataService.getLocationPermissions()),
      FutureProvider<List<Conversation>>.value(
          value: messageService.getConversations()),
      StreamProvider<User>.value(value: appDataService.getUser()),
    ], child: streamUserPings());
  }

  Widget streamUserPings() {
    return Consumer<User>(builder: (context, user, widget) {
      if (user == null) {
        return RegisterScreen();
      }
      return StreamProvider<List<Ping>>.value(
          value: user.streamPings(),
          child: Consumer2<List<Conversation>, List<Ping>>(
              builder: (context, conversations, pings, widget) {
            if (conversations == null || pings == null) {
              return LoadingScreen();
            }
            for (Ping ping in pings) {
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

  Widget streamConversations(conversations) {
    List<Stream> messageStreams = [];
    List<Stream> peerInfoStreams = [];
    List<Stream> groupPingStreams = [];

    if (conversations.isEmpty) {
      return HomeScreen();
    }
    for (Conversation conversation in conversations) {
      messageStreams.add(conversation.streamMessages());
      peerInfoStreams.add(conversation.streamPeerInfo());
      if (conversation.isGroup) {
        groupPingStreams.add(conversation.streamGroupPings());
      }
    }
    return MultiProvider(
        providers: [
          streamMessages(conversations, messageStreams),
          streamPeerInfo(conversations, peerInfoStreams),
          streamGroupPings(conversations, groupPingStreams),
        ],
        child:
            Consumer<List<List<Message>>>(builder: (context, messages, widget) {
          if (messages == null) {
            return LoadingScreen();
          }
          Provider.of<List<Entity>>(context);
          Provider.of<List<Ping>>(context);
          messageService.refreshPings(conversations);

          getGroupUsers(conversations, messages);
          return HomeScreen();
        }));
  }

  StreamProvider<List<List<Message>>> streamMessages(
      conversations, messageStreams) {
    return StreamProvider<List<List<Message>>>.value(
        value: CombineLatestStream(messageStreams, (List<dynamic> messages) {
      int index = 0;
      for (Conversation conv in conversations) {
        conv.messages = messages[index];
        ++index;
      }
      return messages.cast<List<Message>>();
    }));
  }

  StreamProvider<List<Entity>> streamPeerInfo(conversations, peerInfoStreams) {
    return StreamProvider<List<Entity>>.value(
        value: CombineLatestStream(peerInfoStreams, (List<dynamic> peerInfo) {
      int index = 0;
      for (Conversation conv in conversations) {
        conv.peerData = peerInfo[index];
        ++index;
      }
      return peerInfo.cast<Entity>();
    }));
  }

  StreamProvider streamGroupPings(conversations, groupPingStreams) {
    return StreamProvider<List<Ping>>.value(
        value: CombineLatestStream(groupPingStreams, (List<dynamic> pings) {
      int index = 0;
      for (Conversation conv in conversations) {
        if (conv.isGroup) {
          conv.pings = pings[index].length;
          ++index;
        }
      }
      return pings.cast<Ping>();
    }));
  }

  Future<List<Conversation>> getGroupUsers(conversations, messages) async {
    int index = 0;
    for (Conversation conversation in conversations) {
      if (conversation.isGroup) {
        List<Message> m = messages[index];
        List<String> ids =
            m.map((mess) => mess.idFrom).toSet().toList().cast<String>();
        List<User> users =
            await Future.wait(ids.map((id) => userProvider.getUser(id)));
        users = List.from(users);
        users.removeWhere((user) => user == null);

        for (Message mess in conversation.messages) {
          int index = users.indexWhere((user) => user.id == mess.idFrom);
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
      return LoadingScreen();
    }

    return FutureBuilder(
        future: appDataService.getUser().first,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          return getAppData();
        });
  }
}
