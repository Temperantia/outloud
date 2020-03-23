import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';

class EventRegisterAction extends redux.ReduxAction<AppState> {
  EventRegisterAction(this.event);
  final Event event;
  @override
  AppState reduce() {
    final User user = state.userState.user;

    user.events[event.id] = UserEventState.Attending;
    updateUser(user);

    event.memberIds = List<String>.from(event.memberIds + <String>[user.id]);
    updateEvent(event);
    return null;
  }
}
