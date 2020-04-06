import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/people/actions/people_get_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

class _PeopleSearchScreenState extends State<PeopleSearchScreen> {
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
                arguments: <String, dynamic>{
                  'user': user,
                  'isEdition': false
                })),
            child: Row(
              children: <Widget>[
                CachedImage(user.pics.isEmpty ? null : user.pics[0],
                    width: 50.0,
                    height: 50.0,
                    borderRadius: BorderRadius.circular(20.0),
                    imageType: ImageType.User),
                Expanded(
                    // flex: 2,
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
          Container(
              padding: const EdgeInsets.all(15),
              child: GestureDetector(
                onTap: () async {
                  // await dispatchFuture(UserSendFriendRequest(
                  //                 state.userState.user.id, user.id));
                },
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: blue,
                ),
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
          final List<User> people = peopleState.people;
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
