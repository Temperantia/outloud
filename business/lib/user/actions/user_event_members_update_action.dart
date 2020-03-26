import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';

class UserEventMembersUpdateAction extends redux.ReduxAction<AppState> {
  UserEventMembersUpdateAction(this.members, this.eventId);

  final List<User> members;
  final String eventId;

  @override
  AppState reduce() {
    final List<Event> events = state.userState.events;

    final Event event = events.firstWhere((Event event) => event.id == eventId);
    event.members = members;

    return state.copy(userState: state.userState.copy(events: events));
  }
}
