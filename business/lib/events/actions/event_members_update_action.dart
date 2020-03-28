import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';

class EventMembersUpdateAction extends redux.ReduxAction<AppState> {
  EventMembersUpdateAction(this._members, this._eventId);

  final List<User> _members;
  final String _eventId;

  @override
  AppState reduce() {
    final List<Event> events = state.eventsState.events;

    final Event event = events.firstWhere((Event event) => event.id == _eventId,
        orElse: () => null);

    if (event == null) {
      return null;
    }

    event.members = _members;

    return state.copy(eventsState: state.eventsState.copy(events: events));
  }
}
