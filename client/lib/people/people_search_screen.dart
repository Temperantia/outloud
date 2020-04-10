import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:business/user/actions/user_send_friend_request_action.dart';
import 'package:business/user/actions/user_accept_friend_request_action.dart';
import 'package:business/user/actions/user_deny_friend_request_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:outloud/functions/loader_animation.dart';
import 'package:outloud/profile/profile_screen.dart';
import 'package:outloud/widgets/cached_image.dart';
import 'package:outloud/widgets/loading.dart';
import 'package:outloud/widgets/view.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:business/people/people_state.dart';

import 'package:outloud/theme.dart';

class PeopleSearchScreen extends StatefulWidget {
  static const String id = 'PeopleSearch';
  @override
  _PeopleSearchScreenState createState() => _PeopleSearchScreenState();
}

class _PeopleSearchScreenState extends State<PeopleSearchScreen>
    with TickerProviderStateMixin {
  Widget _buildPerson(
    User user,
    String distance,
    Future<void> Function(redux.ReduxAction<AppState>) dispatchFuture,
    void Function(redux.ReduxAction<AppState>) dispatch,
    ThemeStyle theme,
    AppState state,
  ) {
    return Container(
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: () => dispatch(redux.NavigateAction<AppState>.pushNamed(
                ProfileScreen.id,
                arguments: <String, dynamic>{'user': user})),
            child: Row(
              children: <Widget>[
                CachedImage(user.pics.isEmpty ? null : user.pics[0],
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
                            Text(
                              user.name,
                              style: const TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            const Text(
                              'many shared intests',
                              style: TextStyle(
                                  color: orange, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              distance != null
                                  ? ' somewhere : $distance away'
                                  : 'somewhere',
                              style: const TextStyle(
                                  color: orange, fontWeight: FontWeight.w400),
                            ),
                            SingleChildScrollView(
                              child: Row(
                                children: <Widget>[
                                  for (final String _interest in user.interests)
                                    Container(
                                        padding: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        margin: const EdgeInsets.only(
                                            left: 2.0, right: 2.0),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: pinkBright)),
                                        child: Text(_interest.toUpperCase(),
                                            style: const TextStyle(
                                                color: pinkBright,
                                                fontSize: 12)))
                                ],
                              ),
                              scrollDirection: Axis.horizontal,
                            )
                          ],
                        ))),
              ],
            ),
          )),
          if (state.userState.user.pendingFriends.contains(user.id))
            Container(
                child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    margin: const EdgeInsets.only(
                        left: 2.0, right: 2.0, bottom: 10),
                    decoration: BoxDecoration(border: Border.all(color: blue)),
                    child: const Text('PENDING REQUEST',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w300))),
                Row(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        child: GestureDetector(
                            onTap: () async {
                              await showLoaderAnimation(context, this,
                                  animationDuration: 600);
                              dispatch(UserAcceptFriendRequestAction(
                                  user.id, state.userState.user.id));
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: blue,
                                ),
                                const Text('Accept',
                                    style: TextStyle(
                                        color: blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))
                              ],
                            ))),
                    Container(
                        margin: const EdgeInsets.only(left: 15.0),
                        child: GestureDetector(
                            onTap: () async {
                              await showLoaderAnimation(context, this,
                                  animationDuration: 600);
                              dispatch(UserDenyFriendRequestAction(
                                  user.id, state.userState.user.id));
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                  color: blue,
                                ),
                                const Text('Deny',
                                    style: TextStyle(
                                        color: blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400))
                              ],
                            ))),
                  ],
                )
              ],
            ))
          else if (!state.userState.user.requestedFriends.contains(user.id))
            Container(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: GestureDetector(
                      onTap: () async {
                        await dispatchFuture(UserSendFriendRequest(
                            state.userState.user.id, user.id));
                      },
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: blue,
                      ),
                    )))
          else
            Container(
                child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                    margin: const EdgeInsets.only(
                        left: 2.0, right: 2.0, bottom: 10),
                    decoration: BoxDecoration(border: Border.all(color: blue)),
                    child: const Text('REQUEST SENT',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w300))),
                Container(
                    child: GestureDetector(
                        onTap: () async {
                          await showLoaderAnimation(context, this,
                              animationDuration: 600);
                          dispatch(UserDenyFriendRequestAction(
                              state.userState.user.id, user.id));
                        },
                        child: Row(
                          children: <Widget>[
                            const Text('Cancel',
                                style: TextStyle(
                                    color: blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                            Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                  color: blue,
                                )),
                          ],
                        )))
              ],
            ))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return ReduxSelector<AppState, PeopleState>(
        selector: (BuildContext context, AppState state) => state.peopleState,
        builder: (BuildContext context,
            redux.Store<AppState> store,
            AppState state,
            void Function(redux.ReduxAction<AppState>) dispatch,
            PeopleState peopleState,
            Widget child) {
          final List<User> people =
              state.peopleState.people.where((User _user) {
            return !state.userState.user.friends.contains(_user.id) &&
                _user.id != state.userState.user.id;
          }).toList();
          final Map<String, String> distances = peopleState.distances;
          if (people == null || distances == null) {
            return Loading();
          }
          return View(
              child: RefreshIndicator(
                  onRefresh: () => store.dispatchFuture(PeopleGetAction()),
                  child: Container(
                      decoration: const BoxDecoration(color: white),
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                FlutterI18n.translate(
                                    context, 'PEOPLE_SEARCH.PEOPLE'),
                                style: textStyleTitle(state.theme)),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: people.length,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            _buildPerson(
                                                people[index],
                                                distances[people[index].id],
                                                store.dispatchFuture,
                                                dispatch,
                                                state.theme,
                                                state))),
                          ]))));
        });
  }
}
