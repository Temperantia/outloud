import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';

class EventUnRegisterAction extends redux.ReduxAction<AppState> {
  EventUnRegisterAction(this.event);
  final Event event;
  @override
  AppState reduce() {
    final User user = state.userState.user;

    user.events.remove(event.id);
    updateUser(user);

    final List<String> memberIds = List<String>.from(event.memberIds);
    memberIds.remove(user.id);
    event.memberIds = memberIds;
    updateEvent(event);

    return null;
  }
}
