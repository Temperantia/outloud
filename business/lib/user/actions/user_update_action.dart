import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/events.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_events_update_action.dart';
import 'package:business/user/actions/user_friends_update_action.dart';
import 'package:business/user/actions/user_lounges_update_action.dart';

class UserUpdateAction extends redux.ReduxAction<AppState> {
  UserUpdateAction(this.user);

  final User user;

  static StreamSubscription<List<User>> usersSub;
  static StreamSubscription<List<Event>> eventsSub;
  static StreamSubscription<List<Lounge>> loungesSub;

  @override
  AppState reduce() {
    if (usersSub != null) {
      usersSub.cancel();
    }
    usersSub = streamUsers(ids: user.friends).listen(
        (List<User> friends) => dispatch(UserFriendsUpdateAction(friends)));

    if (eventsSub != null) {
      eventsSub.cancel();
    }
    eventsSub = streamEvents(user.events.keys.toList()).listen(
        (List<Event> events) => dispatch(UserEventsUpdateAction(events)));

    if (loungesSub != null) {
      loungesSub.cancel();
    }
    loungesSub = streamLounges(ids: user.lounges).listen(
        (List<Lounge> lounges) => dispatch(UserLoungesUpdateAction(lounges)));

    return state.copy(userState: state.userState.copy(user: user));
  }
}
