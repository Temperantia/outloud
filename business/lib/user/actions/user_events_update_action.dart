import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/models/lounges.dart';
import 'package:business/user/actions/user_event_lounges_update_action.dart';

class UserEventsUpdateAction extends redux.ReduxAction<AppState> {
  UserEventsUpdateAction(this.events);

  final List<Event> events;

  @override
  AppState reduce() {
    final List<String> eventIds =
        events.map((Event event) => event.id).toList();

    streamLounges(eventIds: eventIds).listen((List<Lounge> lounges) =>
        dispatch(UserEventLoungesUpdateAction(lounges)));
    return state.copy(userState: state.userState.copy(events: events));
  }
}
