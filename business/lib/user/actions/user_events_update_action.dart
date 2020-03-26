import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_event_lounges_update_action.dart';
import 'package:business/user/actions/user_event_members_update_action.dart';

class UserEventsUpdateAction extends redux.ReduxAction<AppState> {
  UserEventsUpdateAction(this._events);

  final List<Event> _events;

  static StreamSubscription<List<Lounge>> _eventLoungesSub;
  static final List<StreamSubscription<List<User>>> _membersSubs =
      <StreamSubscription<List<User>>>[];

  @override
  AppState reduce() {
    final List<String> eventIds =
        _events.map((Event event) => event.id).toList();

    if (_eventLoungesSub != null) {
      _eventLoungesSub.cancel();
    }

    _streamUsers();

    _eventLoungesSub = streamLounges(eventIds: eventIds).listen(
        // TODO(me): actually it's a future lol
        (List<Lounge> lounges) =>
            dispatch(UserEventLoungesUpdateAction(lounges)));
    return state.copy(userState: state.userState.copy(events: _events));
  }

  void _streamUsers() {
    for (final StreamSubscription<List<User>> memberSub in _membersSubs) {
      memberSub.cancel();
    }
    _membersSubs.clear();
    for (final Event event in _events) {
      _membersSubs.add(streamUsers(ids: event.memberIds).listen(
          (List<User> members) =>
              dispatch(UserEventMembersUpdateAction(members, event.id))));
    }
  }
}
