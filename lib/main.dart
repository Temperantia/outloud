import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/group_ping.dart';
import 'package:inclusive/classes/ping.dart';
import 'package:inclusive/classes/search_preferences.dart';
import 'package:inclusive/services/search.dart';
import 'package:provider/provider.dart';

import 'package:inclusive/locator.dart';
import 'package:inclusive/routes.dart';
import 'package:inclusive/theme.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/models/group.dart';
import 'package:inclusive/models/message.dart';
import 'package:inclusive/services/app_data.dart';
import 'package:inclusive/services/message.dart';
import 'package:inclusive/classes/conversation_list.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/screens/Register/register.dart';
import 'package:inclusive/screens/home.dart';

void main() {
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  void _streamPings(User user, ConversationList conversationList,
      MessageService messageService) {
    user.streamPings().listen((List<Ping> userPings) {
      String userConversationId;
      for (final Ping userPing in userPings) {
        userConversationId =
            Conversation.getUserConversationId(user.id, userPing.id);
        final int index = conversationList.conversations.indexWhere(
            (Conversation conversation) =>
                conversation.id == userConversationId);
        if (index == -1) {
          conversationList.conversations
              .add(Conversation(userConversationId, pings: userPing.value));
        } else {
          conversationList.conversations[index].pings = userPing.value;
        }
      }
      messageService.refreshPings(conversationList.conversations);
    });
    for (final Conversation conversation in conversationList.conversations) {
      if (conversation.isGroup) {
        conversation.streamGroupPings().listen((GroupPing groupPing) {
          conversation.pings = groupPing.value;
          messageService.refreshPings(conversationList.conversations);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <ChangeNotifierProvider<ChangeNotifier>>[
          ChangeNotifierProvider<UserModel>(
              create: (_) => locator<UserModel>()),
          ChangeNotifierProvider<GroupModel>(
              create: (_) => locator<GroupModel>()),
          ChangeNotifierProvider<MessageModel>(
              create: (_) => locator<MessageModel>()),
          ChangeNotifierProvider<AppDataService>(
              create: (_) => locator<AppDataService>()),
          ChangeNotifierProvider<MessageService>(
              create: (_) => locator<MessageService>()),
          ChangeNotifierProvider<SearchService>(
              create: (_) => locator<SearchService>()),
        ],
        child: Consumer3<AppDataService, MessageService, SearchService>(builder:
            (BuildContext context,
                AppDataService appDataService,
                MessageService messageService,
                SearchService searchService,
                Widget w) {
          return MultiProvider(
              providers: <SingleChildCloneableWidget>[
                StreamProvider<User>.value(value: appDataService.getUser()),
                FutureProvider<ConversationList>.value(
                    value: messageService.getConversationList()),
                FutureProvider<SearchPreferences>.value(
                    value: searchService.getSearchPreferences()),
              ],
              child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: theme,
                  title: 'Inc•lusive',
                  initialRoute: HomeScreen.id,
                  onGenerateRoute: (RouteSettings settings) {
                    final String name = settings.name;
                    return MaterialPageRoute<Widget>(
                        builder: (BuildContext context) {
                      final User user = Provider.of(context);
                      return !name.startsWith('Register') &&
                              name != 'Login' &&
                              user != null
                          ? RegisterScreen()
                          : Consumer<ConversationList>(builder:
                              (BuildContext context,
                                  ConversationList conversationList, Widget w) {
                              if (conversationList != null) {
                                _streamPings(
                                    user, conversationList, messageService);
                              }

                              return routes[settings.name](settings.arguments);
                            });
                    });
                  }));
        }));
  }
}
