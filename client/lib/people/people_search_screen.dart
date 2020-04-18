import 'package:async_redux/async_redux.dart'
    show ReduxAction, NavigateAction, Store;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/user/actions/user_send_friend_request_action.dart';
import 'package:business/user/actions/user_accept_friend_request_action.dart';
import 'package:business/user/actions/user_deny_friend_request_action.dart';
import 'package:flutter/material.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';

import 'package:outloud/theme.dart';

class PeopleSearchScreen extends StatefulWidget {
  static const String id = 'PeopleSearch';
  @override
  _PeopleSearchScreenState createState() => _PeopleSearchScreenState();
}

class _PeopleSearchScreenState extends State<PeopleSearchScreen>
    with TickerProviderStateMixin {
  void Function(ReduxAction<AppState>) _dispatch;

  Widget _buildPerson(User person, User user, String distance) {
    return Column(children: <Widget>[
      const Divider(),
      GestureDetector(
          onTap: () => _dispatch(NavigateAction<AppState>.pushNamed(
              ProfileScreen.id,
              arguments: <String, dynamic>{'user': person})),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0)),
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(children: <Widget>[
                Expanded(
                    child: Row(children: <Widget>[
                  CachedImage(person.pics.isEmpty ? null : person.pics[0],
                      width: 50.0,
                      height: 50.0,
                      borderRadius: BorderRadius.circular(20.0),
                      imageType: ImageType.User),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AutoSizeText(
                                  person.name,
                                  style: const TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                /*  const AutoSizeText(
                                  'many shared intests',
                                  style: TextStyle(
                                      color: orange, fontWeight: FontWeight.w400),
                                ), */
                                /* AutoSizeText(
                                  distance != null
                                      ? ' somewhere : $distance away'
                                      : 'somewhere',
                                  style: const TextStyle(
                                      color: orange, fontWeight: FontWeight.w400),
                                ), */
                                SingleChildScrollView(
                                    child: Row(children: <Widget>[
                                      for (final String _interest
                                          in person.interests)
                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 2.0, right: 2.0),
                                            margin: const EdgeInsets.only(
                                                left: 2.0, right: 2.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: pinkBright)),
                                            child: AutoSizeText(
                                                _interest.toUpperCase(),
                                                style: const TextStyle(
                                                    color: pinkBright,
                                                    fontSize: 12)))
                                    ]),
                                    scrollDirection: Axis.horizontal)
                              ])))
                ])),
                if (user.pendingFriends.contains(user.id))
                  Column(children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                        margin: const EdgeInsets.only(
                            left: 2.0, right: 2.0, bottom: 10),
                        decoration:
                            BoxDecoration(border: Border.all(color: blue)),
                        child: const AutoSizeText('REQUETE EN ATTENTE',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w300))),
                    Row(children: <Widget>[
                      Container(
                          margin: const EdgeInsets.only(right: 15.0),
                          child: GestureDetector(
                              onTap: () async {
                                /* await showLoaderAnimation(context, this,
                                    animationDuration: 600); */
                                _dispatch(UserAcceptFriendRequestAction(
                                    person.id, user.id));
                              },
                              child: Column(children: <Widget>[
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: blue,
                                ),
                                const AutoSizeText('Accepter',
                                    style: TextStyle(
                                        color: blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))
                              ]))),
                      Container(
                          margin: const EdgeInsets.only(left: 15.0),
                          child: GestureDetector(
                              onTap: () async {
                                /* await showLoaderAnimation(context, this,
                                    animationDuration: 600); */
                                _dispatch(UserDenyFriendRequestAction(
                                    person.id, user.id));
                              },
                              child: Column(children: <Widget>[
                                Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                  color: blue,
                                ),
                                const AutoSizeText('Refuser',
                                    style: TextStyle(
                                        color: blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))
                              ])))
                    ])
                  ])
                else if (!user.requestedFriends.contains(person.id))
                  Container(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                          onTap: () => _dispatch(
                              UserSendFriendRequest(user.id, person.id)),
                          child: Icon(Icons.add, size: 40, color: blue)))
                else
                  Column(children: <Widget>[
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
                        onTap: () async {
                          /* await showLoaderAnimation(context, this,
                              animationDuration: 600); */
                          _dispatch(
                              UserDenyFriendRequestAction(user.id, person.id));
                        },
                        child: Row(children: <Widget>[
                          const AutoSizeText('Annuler',
                              style: TextStyle(
                                  color: blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                          Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Icon(Icons.remove_circle_outline,
                                  size: 20, color: blue))
                        ]))
                  ])
              ])))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(builder: (BuildContext context,
        Store<AppState> store,
        AppState state,
        void Function(ReduxAction<AppState>) dispatch,
        Widget child) {
      _dispatch = dispatch;
      final List<User> people = state.peopleState.people.where((User _user) {
        return !state.userState.user.friends.contains(_user.id) &&
            _user.id != state.userState.user.id;
      }).toList();
      final Map<String, String> distances = state.peopleState.distances;
      if (people == null /*  || distances == null */) {
        return Loading();
      }
      return View(
          title: 'TROUVE DES AMIS',
          child: RefreshIndicator(
            onRefresh: () => store.dispatchFuture(PeopleGetAction()),
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: people.length,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildPerson(people[index], state.userState.user,
                            distances[people[index].id]))),
          ));
    });
  }
}
