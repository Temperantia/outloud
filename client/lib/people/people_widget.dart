import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/chats/chat_screen.dart';
import 'package:outloud/people/people_search_screen.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

import '../theme.dart';

class PeopleWidget extends StatefulWidget {
  @override
  _PeopleWidgetState createState() => _PeopleWidgetState();
}

class _PeopleWidgetState extends State<PeopleWidget>
    with AutomaticKeepAliveClientMixin<PeopleWidget> {
  @override
  bool get wantKeepAlive => true;

  Widget _buildPerson(User user, ThemeStyle theme,
      void Function(ReduxAction<AppState>) dispatch) {
    return GestureDetector(
        onTap: () => dispatch(NavigateAction<AppState>.pushNamed(
            ProfileScreen.id,
            arguments: <String, dynamic>{'user': user, 'isEdition': false})),
        child: Container(
            decoration: BoxDecoration(
                color: primary(theme),
                borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(children: <Widget>[
              CachedImage(user.pics.isEmpty ? null : user.pics[0],
                  width: 50.0,
                  height: 50.0,
                  borderRadius: BorderRadius.circular(20.0),
                  imageType: ImageType.User),
              Expanded(
                  flex: 3,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(user.name))),
            ])));
  }

  Widget _buildFriends(List<User> friends, ThemeStyle theme,
      void Function(ReduxAction<AppState>) dispatch) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          Expanded(
              flex: 5,
              child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildPerson(friends[index], theme, dispatch))),
          Expanded(
              child: Button(
                  text: FlutterI18n.translate(context, 'PEOPLE_TAB.FIND_MORE'),
                  onPressed: () => dispatch(NavigateAction<AppState>.pushNamed(
                      PeopleSearchScreen.id)))),
        ]));
  }

  Widget _buildChat(Chat chat, ThemeStyle theme,
      void Function(ReduxAction<AppState>) dispatch) {
    final Message lastMessage = chat.messages.isEmpty ? null : chat.messages[0];
    final String pic = (chat.entity as User).pics.isEmpty
        ? null
        : (chat.entity as User).pics[0];
    return GestureDetector(
        onTap: () => dispatch(
            NavigateAction<AppState>.pushNamed(ChatScreen.id, arguments: chat)),
        child: Container(
            decoration: BoxDecoration(
                color: primary(theme),
                borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(children: <Widget>[
              CachedImage(pic,
                  width: 50.0,
                  height: 50.0,
                  borderRadius: BorderRadius.circular(20.0),
                  imageType: ImageType.User),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(chat.entity.name,
                                      style: textStyleListItemTitle),
                                  if (lastMessage != null)
                                    Text(lastMessage.getTimeAgo(),
                                        style: textStyleListItemSubtitle),
                                ]),
                            if (lastMessage != null)
                              Row(children: <Widget>[
                                Text(lastMessage.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)
                              ]),
                          ]))),
            ])));
  }

  Widget _buildChats(List<Chat> chats, ThemeStyle theme,
      void Function(ReduxAction<AppState>) dispatch) {
    return ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildChat(chats[index], theme, dispatch));
  }

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
            Expanded(
                child: TabBar(
                    labelColor: white,
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                  Tab(
                      text:
                          FlutterI18n.translate(context, 'PEOPLE_TAB.FRIENDS')),
                  Tab(text: FlutterI18n.translate(context, 'PEOPLE_TAB.CHATS')),
                ])),
            Expanded(
                flex: 8,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      _buildFriends(friends, state.theme, dispatch),
                      _buildChats(chats, state.theme, dispatch),
                    ])),
          ]));
    });
  }
}
