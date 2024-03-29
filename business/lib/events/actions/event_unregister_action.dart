import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';

class EventUnRegisterAction extends redux.ReduxAction<AppState> {
  EventUnRegisterAction(this._event);

  final Event _event;

  @override
  AppState reduce() {
    final User user = state.userState.user;
    updateUser(user..events.remove(_event.id));

    updateEvent(_event
      ..memberIds = (List<String>.from(_event.memberIds)..remove(user.id)));

    return null;
  }
}
