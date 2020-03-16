import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/models/lounges.dart';
import 'package:business/user/actions/user_event_lounges_update_action.dart';

class UserEventsUpdateAction extends redux.ReduxAction<AppState> {
  UserEventsUpdateAction(this.events);

  final List<Event> events;

  static StreamSubscription<List<Lounge>> eventLoungesSub;

  @override
  AppState reduce() {
    final List<String> eventIds =
        events.map((Event event) => event.id).toList();

    if (eventLoungesSub != null) {
      eventLoungesSub.cancel();
    }

    eventLoungesSub = streamLounges(eventIds: eventIds).listen(
        // TODO(me): actually it's a future lol
        (List<Lounge> lounges) =>
            dispatch(UserEventLoungesUpdateAction(lounges)));
    return state.copy(userState: state.userState.copy(events: events));
  }
}
