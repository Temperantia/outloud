import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:async_redux/async_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/people/people_search_screen.dart';
import 'package:business/user/actions/user_accept_friend_request_action.dart';
import 'package:business/chats/actions/chats_create_action.dart';
import 'package:business/user/actions/user_deny_friend_request_action.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/widgets/button.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/content_list.dart';
import 'package:outloud/widgets/content_list_item.dart';
import 'package:outloud/widgets/people_search.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

import 'package:outloud/theme.dart';

class PeopleFriendsScreen extends StatefulWidget {
  @override
  _PeopleFriendsScreenState createState() => _PeopleFriendsScreenState();
}

class _PeopleFriendsScreenState extends State<PeopleFriendsScreen>
    with
        AutomaticKeepAliveClientMixin<PeopleFriendsScreen>,
        TickerProviderStateMixin {
  void Function(ReduxAction<AppState>) _dispatch;
  @override
  bool get wantKeepAlive => true;

  Widget _buildPerson(User user) {
    return ContentListItem(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            ProfileScreen.id,
            arguments: <String, dynamic>{'user': user})),
        leading: CachedImage(user.pics.isEmpty ? null : user.pics[0],
            width: 40.0,
            height: 40.0,
            borderRadius: BorderRadius.circular(20.0),
            imageType: ImageType.User),
        title: Container(
            padding: const EdgeInsets.only(left: 15.0),
            child: Wrap(children: <Widget>[
              AutoSizeText(user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15))
            ])),
        trailing: GestureDetector(
            onTap: () => _dispatch(ChatsCreateAction(user.id)),
            child: Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                decoration: BoxDecoration(
                    color: orange, border: Border.all(color: orange)),
                child: AutoSizeText(
                    FlutterI18n.translate(context, 'PEOPLE_TAB.SEND_MESSAGE')
                        .toUpperCase(),
                    style: const TextStyle(
                        color: white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)))));
  }

  Widget _buildFriendRequest(User user, String userId) {
    return ContentListItem(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            ProfileScreen.id,
            arguments: <String, dynamic>{'user': user})),
        leading: CachedImage(user.pics.isEmpty ? null : user.pics[0],
            width: 40.0,
            height: 40.0,
            borderRadius: BorderRadius.circular(20.0),
            imageType: ImageType.User),
        title: Container(
            padding: const EdgeInsets.only(left: 15.0),
            child: Wrap(children: <Widget>[
              AutoSizeText(user.name,
                  style: const TextStyle(
                      color: white, fontWeight: FontWeight.w600, fontSize: 16))
            ])),
        trailing: Row(children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () =>
                      _dispatch(UserAcceptFriendRequestAction(user.id, userId)),
                  child: Column(children: const <Widget>[
                    Icon(Icons.add_circle_outline, size: 30.0, color: white),
                    AutoSizeText('ACCEPTER',
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w300,
                            fontSize: 10))
                  ]))),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () =>
                      _dispatch(UserDenyFriendRequestAction(user.id, userId)),
                  child: Column(children: const <Widget>[
                    Icon(Icons.remove_circle_outline, size: 30, color: white),
                    AutoSizeText('REFUSER',
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w300,
                            fontSize: 10))
                  ])))
        ]));
  }

  Widget _buildPendingFriends(List<User> pendingFriends, String userId) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        color: blue,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                  pendingFriends.length > 1
                      ? 'NOUVELLES DEMANDES D\'AMI'
                      : 'NOUVELLE DEMANDE D\'AMI',
                  style: const TextStyle(
                      color: white, fontWeight: FontWeight.w600, fontSize: 12)),
              Expanded(
                  child: ContentList<User>(
                      items: pendingFriends,
                      builder: (User friend) =>
                          _buildFriendRequest(friend, userId)))
            ]));
  }

  Widget _buildFriends(List<User> friends) {
    return ContentList<User>(
        items: friends,
        builder: (User friend) => _buildPerson(friend),
        whenEmpty: PeopleSearch());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;

      final List<User> friends = state.userState.friends;
      final List<User> pendingFriends = state.userState.pendingFriends;

      return Column(children: <Widget>[
        if (pendingFriends.isNotEmpty)
          Flexible(
              flex: pendingFriends.length > 1 ? 4 : 3,
              child: _buildPendingFriends(
                  pendingFriends, state.userState.user.id)),
        Expanded(
            flex: pendingFriends.length > 1 ? 6 : 7,
            child: _buildFriends(friends)),
        if (friends.isNotEmpty)
          Container(
              padding: const EdgeInsets.only(top: 5.0),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[pinkLight, pink])),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Button(
                        text: FlutterI18n.translate(
                            context, 'PEOPLE_TAB.FIND_MORE'),
                        width: 250,
                        onPressed: () => dispatch(
                            NavigateAction<AppState>.pushNamed(
                                PeopleSearchScreen.id)))
                  ]))
      ]);
    });
  }
}
