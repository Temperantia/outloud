import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';

class EventRegisterAction extends redux.ReduxAction<AppState> {
  EventRegisterAction(this._event);
  final Event _event;
  @override
  AppState reduce() {
    final User user = state.userState.user;

    user.events[_event.id] = UserEventState.Attending;
    updateUser(user);

    _event.memberIds = List<String>.from(_event.memberIds + <String>[user.id]);
    updateEvent(_event);

    return null;
  }
}
