import 'package:badges/badges.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/screens/Landing/index.dart';
import 'package:inclusive/screens/Messaging/index.dart';
import 'package:inclusive/screens/Profile/profile-edition.dart';

import 'package:inclusive/screens/Search/index.dart';
import 'package:inclusive/screens/loading.dart';
import 'package:inclusive/services/appdata.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/screens/Profile/profile.dart';
import 'package:inclusive/widgets/background.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/classes/ping.dart';

import 'package:location_permissions/location_permissions.dart';

import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<MessagingState> messaging = GlobalKey<MessagingState>();

  AppDataService appDataService;
  MessageService messageService;
  UserModel userProvider;
  User user;
  TabController tabController;
  int currentPage = 2;
  bool editProfile = false;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    AppDataService.checkInternet()
        .then((connected) => setState(() => this.connected = connected));
    tabController =
        TabController(initialIndex: currentPage, vsync: this, length: 5);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  getAppData() {
    return MultiProvider(providers: [
      FutureProvider<PermissionStatus>.value(
          value: appDataService.getLocationPermissions()),
      FutureProvider<List<Conversation>>.value(
          value: messageService.getConversations()),
      StreamProvider<User>.value(value: appDataService.getUser()),
    ], child: streamUserPings());
  }

  streamUserPings() {
    return Consumer<User>(builder: (context, user, widget) {
      if (user == null) {
        return LoadingScreen();
      }
      this.user = user;
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
          messageService.refreshPings();

          getGroupUsers(conversations, messages).then((convs) {
            messageService.conversations = convs;
          });
          return buildView();
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

  void onSaveProfile(User user) {
    userProvider.updateUser(user, user.id);
    setState(() => editProfile = false);
  }

  Widget _body() {
    return Container(
        decoration: background,
        child: TabBarView(controller: tabController, children: [
          editProfile
              ? ProfileEditionScreen(user, onSaveProfile)
              : Profile(user),
          MessagingScreen(key: messaging),
          SearchScreen(),
          SearchScreen(),
          SearchScreen(),
        ]));
  }

  void onChangePage(final int index) {
    setState(() {
      currentPage = index;
      tabController.animateTo(index);
    });
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
          if (snap.data == null) {
            return LandingScreen();
          }
          return getAppData();
        });
  }

  List<SpeedDialChild> buildActions() {
    final List<SpeedDialChild> actions = [];

    if (tabController.index == 0) {
      actions.add(SpeedDialChild(
          backgroundColor: orange,
          child: Icon(editProfile ? Icons.cancel : Icons.edit, color: white),
          onTap: () => setState(() => editProfile = !editProfile)));
    } else if (tabController.index == 1) {
      actions.add(SpeedDialChild(
          backgroundColor: orange,
          child: Icon(Icons.close, color: white),
          onTap: () => messaging.currentState.onCloseConversation()));
    }
    return actions;
  }

  buildView() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: SpeedDial(
            child: Icon(Icons.add, color: white),
            backgroundColor: orange,
            animatedIcon: AnimatedIcons.menu_close,
            foregroundColor: white,
            overlayOpacity: 0,
            children: buildActions()),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
            fabLocation: BubbleBottomBarFabLocation.end,
            opacity: 1,
            currentIndex: currentPage,
            onTap: onChangePage,
            hasInk: true,
            items: [
              BubbleBottomBarItem(
                  icon: Icon(Icons.person, color: orange),
                  activeIcon: Icon(Icons.person, color: white),
                  backgroundColor: orange,
                  title: Text('Me',
                      style: TextStyle(color: white, fontSize: 14.0))),
              BubbleBottomBarItem(
                  icon: messageService.pings > 0
                      ? Badge(
                          badgeColor: orange,
                          badgeContent: Text(messageService.pings.toString(),
                              style: Theme.of(context).textTheme.caption),
                          child: Icon(Icons.message, color: orange))
                      : Icon(Icons.message, color: orange),
                  activeIcon: Icon(Icons.message, color: white),
                  backgroundColor: orange,
                  title: Text('Message',
                      style: TextStyle(color: white, fontSize: 14.0))),
              BubbleBottomBarItem(
                  icon: Icon(Icons.search, color: orange),
                  activeIcon: Icon(Icons.search, color: white),
                  backgroundColor: orange,
                  title: Text('Search',
                      style: TextStyle(color: white, fontSize: 14.0))),
              BubbleBottomBarItem(
                  icon: Icon(Icons.people, color: orange),
                  activeIcon: Icon(Icons.people, color: white),
                  backgroundColor: orange,
                  title: Text('Group',
                      style: TextStyle(color: white, fontSize: 14.0))),
              BubbleBottomBarItem(
                  icon: Icon(Icons.event, color: orange),
                  activeIcon: Icon(Icons.event, color: white),
                  backgroundColor: orange,
                  title: Text('Event',
                      style: TextStyle(color: white, fontSize: 14.0))),
            ]),
        body: SafeArea(child: _body()));
  }
}
