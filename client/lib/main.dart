import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:business/app_state.dart';
import 'package:inclusive/register/login_connector_widget.dart';

import 'package:inclusive/locator.dart';
import 'package:inclusive/theme.dart';

Store<AppState> store;

void main() {
  store = Store<AppState>(initialState: AppState.initialState());
  setupLocator();
  runApp(App());
}

class App extends StatelessWidget {
  /*
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
*/
  @override
  Widget build(BuildContext context) {
    return /* MultiProvider(
        providers: <ChangeNotifierProvider<ChangeNotifier>>[
          ChangeNotifierProvider<UserModel>(
              create: (_) => locator<UserModel>()),
          ChangeNotifierProvider<GroupModel>(
              create: (_) => locator<GroupModel>()),
          ChangeNotifierProvider<MessageModel>(
              create: (_) => locator<MessageModel>()),
          ChangeNotifierProvider<AppDataService>(
              create: (_) => locator<AppDataService>()),
          ChangeNotifierProvider<AuthService>(
              create: (_) => locator<AuthService>()),
          ChangeNotifierProvider<MessageService>(
              create: (_) => locator<MessageService>()),
          ChangeNotifierProvider<SearchService>(
              create: (_) => locator<SearchService>()),
        ],
        child: Consumer3<AuthService, MessageService, SearchService>(builder:
            (BuildContext context,
                AuthService authService,
                MessageService messageService,
                SearchService searchService,
                Widget w) {
          return MultiProvider(
              providers: <SingleChildCloneableWidget>[
                StreamProvider<User>.value(value: authService.streamUser()),
                FutureProvider<ConversationList>.value(
                    value: messageService.getConversationList()),
                FutureProvider<SearchPreferences>.value(
                    value: searchService.getSearchPreferences()),
              ],
              child:
              */
        StoreProvider<AppState>(
            store: store,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              title: 'Inc•lusive',
              home: LoginConnectorWidget(),
              /*
                initialRoute: RegisterScreen.id,
                onGenerateRoute: (RouteSettings settings) {
                  final String name = settings.name;
                  return MaterialPageRoute<Widget>(
                      builder: (BuildContext context) {
                    //final User user = Provider.of(context);
                    /*return !name.startsWith('Register') &&
                            name != 'Login' &&
                            user == null
                        ? RegisterScreen() */
                    /*: Consumer<ConversationList>(builder:
                            (BuildContext context,
                                ConversationList conversationList, Widget w) {
                                  */
                    /*
                              if (conversationList != null && user != null) {
                                _streamPings(
                                    user, conversationList, messageService);
                              }
*/
                    return routes[name](settings.arguments);
                    //});
                                      });
                }*/
            ));
    /*);
        }));
        */
  }
}
