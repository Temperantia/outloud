import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:outloud/people/people_chat_screen.dart';
import 'package:outloud/people/people_friends_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';


class PeopleWidget extends StatefulWidget {
  @override
  _PeopleWidgetState createState() => _PeopleWidgetState();
}

class _PeopleWidgetState extends State<PeopleWidget>
    with AutomaticKeepAliveClientMixin<PeopleWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      final User user = state.userState.user;
      final List<User> friends = state.userState.friends;
      final List<Chat> chats = state.chatsState.chats;
      if (user == null || friends == null || chats == null) {
        return Loading();
      }
      return DefaultTabController(
          length: 2,
          child: Column(children: <Widget>[
            const Expanded(
                child: TabBar(
                    labelColor: white,
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                  Tab(text: 'CHATS'),
                  Tab(text: 'FRIENDS'),
                ])),
            Expanded(
                flex: 8,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      PeopleChatScreen(),
                      PeopleFriendsScreen()
                    ])),
          ]));
    });
  }
}
