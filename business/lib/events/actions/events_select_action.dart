import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';

class EventsSelectAction extends redux.ReduxAction<AppState> {
  EventsSelectAction(this.event);
  final Event event;

  @override
  AppState reduce() {
    return state.copy(eventsState: state.eventsState.copy(event: event));
  }
}
