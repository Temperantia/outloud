import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';

class EventsGetAction extends redux.ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final List<Event> events = await getEvents();

    return state.copy(eventsState: state.eventsState.copy(events: events));
  }
}
