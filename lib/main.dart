import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/classes/ping.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/home.dart';
import 'package:inclusive/theme.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/group.dart';
import 'package:inclusive/models/message.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/services/message.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  AppDataService appDataService;
  MessageService messageService;
  UserModel userProvider;

  Widget getAppData() {
    return MultiProvider(providers: [
      StreamProvider<User>.value(value: appDataService.getUser()),
      FutureProvider<PermissionStatus>.value(
          value: appDataService.getLocationPermissions()),
      FutureProvider<List<Conversation>>.value(
          value: messageService.getConversations()),
    ], child: getUser());
  }

  Widget getUser() {
    return FutureBuilder(
        future: appDataService.getUser().first,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          final User user = snapshot.data;
          if (user == null) {
            return app(LandingScreen.id);
          }
          return streamUserPings(user);
        });
  }

  Widget streamUserPings(User user) {
    return StreamBuilder(
        stream: user.streamPings(),
        builder: (context, snapshot) {
          final List<Conversation> conversations =
              Provider.of<List<Conversation>>(context);
          List<Ping> pings = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
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
            ++messageService.pings;
          }
          return streamConversations(conversations);
        });
  }

  Widget streamConversations(conversations) {
    List<Stream> messageStreams = [];
    List<Stream> peerInfoStreams = [];
    List<Stream> groupPingStreams = [];

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
        child: Builder(builder: (context) {
          List<List<Message>> messages =
              Provider.of<List<List<Message>>>(context);
          return FutureBuilder(
              future: getGroupUsers(conversations, messages),
              builder: (context, snapshot) {
                Provider.of<dynamic>(context);
                Provider.of<List<Ping>>(context);

                messageService.conversations = snapshot.data;
                return app(HomeScreen.id);
              });
        }));
  }

  StreamProvider streamMessages(conversations, messageStreams) {
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

  StreamProvider streamPeerInfo(conversations, peerInfoStreams) {
    return StreamProvider<dynamic>.value(
        value: CombineLatestStream(peerInfoStreams, (List<dynamic> peerInfo) {
      int index = 0;
      for (Conversation conv in conversations) {
        conv.peerData = peerInfo[index];
        ++index;
      }
      return peerInfo;
    }));
  }

  StreamProvider streamGroupPings(conversations, groupPingStreams) {
    return StreamProvider<List<Ping>>.value(
        value: CombineLatestStream(groupPingStreams, (List<dynamic> pings) {
      int index = 0;
      for (Conversation conv in conversations) {
        if (conv.isGroup) {
          conv.pings = pings[index].length;
          if (pings[index].length > 0) {
            ++messageService.pings;
          }
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

  MaterialApp app(final String initialRoute) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Inclusive',
      initialRoute: initialRoute,
      onGenerateRoute: (RouteSettings settings) {
        final Function createRoute = routes[settings.name];
        return MaterialPageRoute(
            builder: (context) => createRoute(settings.arguments));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => locator<UserModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<GroupModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<MessageModel>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<AppDataService>(),
          ),
          ChangeNotifierProvider(
            create: (_) => locator<MessageService>(),
          ),
        ],
        child: Builder(builder: (context) {
          appDataService = Provider.of<AppDataService>(context);
          messageService = Provider.of<MessageService>(context);
          userProvider = Provider.of<UserModel>(context);
          return getAppData();
        }));
  }
}
