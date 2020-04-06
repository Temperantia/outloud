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
import 'package:business/user/actions/user_pending_friends_update_action.dart';

class UserUpdateAction extends redux.ReduxAction<AppState> {
  UserUpdateAction(this._user);

  final User _user;

  static StreamSubscription<List<User>> usersSub;
  static StreamSubscription<List<Event>> eventsSub;
  static StreamSubscription<List<Lounge>> loungesSub;

  @override
  AppState reduce() {
    _reset();
    loungesSub = streamLounges(ids: _user.lounges).listen(
        (List<Lounge> lounges) => dispatch(UserLoungesUpdateAction(lounges)));

    usersSub = streamUsers(ids: _user.friends).listen((List<User> friends) {
      dispatch(UserFriendsUpdateAction(friends));
      dispatch(UserPendingFriendsUpdateAction(friends));
    });

    eventsSub = streamEvents(_user.events.keys.toList()).listen(
        (List<Event> events) => dispatch(UserEventsUpdateAction(events)));

    return state.copy(userState: state.userState.copy(user: _user));
  }

  void _reset() {
    if (usersSub != null) {
      usersSub.cancel();
    }

    if (eventsSub != null) {
      eventsSub.cancel();
    }

    if (loungesSub != null) {
      loungesSub.cancel();
    }
  }
}
