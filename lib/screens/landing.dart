import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:provider/provider.dart';
import 'package:location_permissions/location_permissions.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/widgets/loading.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/ping.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({this.child});
  final Widget child;
  static const String id = 'Landing';
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<LandingScreen> {
  AppDataService appDataService;
  MessageService messageService;
  UserModel userProvider;

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
      FutureProvider<ConversationList>.value(
          value: messageService.getConversationList()),
      StreamProvider<User>.value(value: appDataService.getUser()),
    ]);
  }

  Widget streamUserPings() {
    return Consumer2<User, ConversationList>(builder: (BuildContext context,
        User user, ConversationList conversationList, Widget w) {
      if (user == null) {
        //return RegisterScreen();
      }
      return StreamProvider<List<Ping>>.value(
          value: user.streamPings(),
          child: Consumer<List<Ping>>(
              builder: (BuildContext context, List<Ping> pings, Widget w) {
            if (pings == null) {
              return Loading();
            }

            if (conversationList.conversations.isEmpty) {
              return widget.child;
            }
            for (final Ping ping in pings) {
              final int index = conversationList.conversations.indexWhere(
                  (final Conversation conversation) =>
                      conversation.idPeer == ping.id);
              if (index == -1) {
                conversationList.conversations
                    .insert(0, Conversation(ping.id, 0, pings: ping.value));
              } else {
                conversationList.conversations[index].pings = ping.value;
              }
            }
            return streamConversations(conversationList.conversations);
          }));
    });
  }

  Widget streamConversations(List<Conversation> conversations) {
    messageService.refreshPings(conversations);

    //getGroupUsers(conversations, messageLists);
    appDataService.loading = false;
    return widget.child;
  }

  @override
  Widget build(BuildContext context) {
    appDataService = Provider.of<AppDataService>(context);
    messageService = Provider.of<MessageService>(context);
    userProvider = Provider.of<UserModel>(context);
    if (!connected) {
      return widget.child;
    }

    return getAppData();
  }
}
