import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';

class UserEventsUpdateAction extends redux.ReduxAction<AppState> {
  UserEventsUpdateAction(this.events);
  final List<Event> events;
  @override
  AppState reduce() {
    return state.copy(userState: state.userState.copy(events: events));
  }
}
