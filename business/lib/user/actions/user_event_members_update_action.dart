import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';

class UserEventMembersUpdateAction extends redux.ReduxAction<AppState> {
  UserEventMembersUpdateAction(this._members, this._eventId);

  final List<User> _members;
  final String _eventId;

  @override
  AppState reduce() {
    final List<Event> events = state.userState.events;

    if (events == null) {
      return null;
    }

    final Event event = events.firstWhere((Event event) => event.id == _eventId,
        orElse: () => null);

    if (event == null) {
      return null;
    }

    event.members = _members;

    return state.copy(userState: state.userState.copy(events: events));
  }
}
