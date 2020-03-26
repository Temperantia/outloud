import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';

class EventMembersUpdateAction extends redux.ReduxAction<AppState> {
  EventMembersUpdateAction(this.members, this.eventId);

  final List<User> members;
  final String eventId;

  @override
  AppState reduce() {
    final List<Event> events = state.eventsState.events;

    final Event event = events.firstWhere((Event event) => event.id == eventId);
    event.members = members;

    return state.copy(eventsState: state.eventsState.copy(events: events));
  }
}
