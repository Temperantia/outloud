import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/user/actions/user_accept_friend_request_action.dart';
import 'package:business/user/actions/user_deny_friend_request_action.dart';
import 'package:business/user/actions/user_send_friend_request_action.dart';
import 'package:flutter/material.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/theme.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/content_list.dart';
import 'package:outloud/widgets/content_list_item.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

class PeopleSearch extends StatefulWidget {
  @override
  _PeopleSearchState createState() => _PeopleSearchState();
}

class _PeopleSearchState extends State<PeopleSearch> {
  void Function(ReduxAction<AppState>) _dispatch;

  Widget _buildPerson(User person, User user) {
    return ContentListItem(
        onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
            ProfileScreen.id,
            arguments: <String, dynamic>{'user': person})),
        leading: CachedImage(person.pics.isEmpty ? null : person.pics[0],
            width: 50.0,
            height: 50.0,
            borderRadius: BorderRadius.circular(20.0),
            imageType: ImageType.User),
        title: AutoSizeText(person.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: SingleChildScrollView(
            child: Row(children: <Widget>[
              for (final String _interest in person.interests)
                Container(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: pinkBright)),
                    child: AutoSizeText(_interest.toUpperCase(),
                        style:
                            const TextStyle(color: pinkBright, fontSize: 12)))
            ]),
            scrollDirection: Axis.horizontal),
        trailing: user.pendingFriends.contains(user.id)
            ? Column(children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    margin: const EdgeInsets.only(
                        left: 2.0, right: 2.0, bottom: 10),
                    decoration: BoxDecoration(border: Border.all(color: blue)),
                    child: const AutoSizeText('REQUETE EN ATTENTE',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w300))),
                Row(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(right: 15.0),
                      child: GestureDetector(
                          onTap: () => _dispatch(UserAcceptFriendRequestAction(
                              person.id, user.id)),
                          child: Column(children: const <Widget>[
                            Icon(Icons.add_circle_outline,
                                size: 20, color: blue),
                            AutoSizeText('Accepter',
                                style: TextStyle(
                                    color: blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))
                          ]))),
                  Container(
                      margin: const EdgeInsets.only(left: 15.0),
                      child: GestureDetector(
                          onTap: () => _dispatch(
                              UserDenyFriendRequestAction(person.id, user.id)),
                          child: Column(children: const <Widget>[
                            Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                              color: blue,
                            ),
                            AutoSizeText('Refuser',
                                style: TextStyle(
                                    color: blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400))
                          ])))
                ])
              ])
            : (!user.requestedFriends.contains(person.id))
                ? Container(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                        onTap: () => _dispatch(
                            UserSendFriendRequest(user.id, person.id)),
                        child: Icon(Icons.add, size: 40, color: blue)))
                : Column(children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        margin: const EdgeInsets.only(
                            left: 2.0, right: 2.0, bottom: 10),
                        decoration:
                            BoxDecoration(border: Border.all(color: blue)),
                        child: const AutoSizeText('REQUETE ENVOYEE',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w300))),
                    GestureDetector(
                        onTap: () async => _dispatch(
                            UserDenyFriendRequestAction(user.id, person.id)),
                        child: Row(children: <Widget>[
                          const AutoSizeText('Annuler',
                              style: TextStyle(
                                  color: blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                          Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: const Icon(Icons.remove_circle_outline,
                                  size: 20, color: blue))
                        ]))
                  ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;

      final User user = state.userState.user;
      final List<User> people = state.peopleState.people.where((User person) {
        return !user.friends.contains(person.id) && person.id != user.id;
      }).toList();
      // final Map<String, String> distances = state.peopleState.distances;
      if (people == null /*  || distances == null */) {
        return const Loading();
      }
      return ContentList<User>(
          onRefresh: () => store.dispatchFuture(PeopleGetAction()),
          items: people,
          builder: (User person) => _buildPerson(person, user));
    });
  }
}
