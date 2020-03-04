import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/models/user.dart';

class EventRegisterAction extends redux.ReduxAction<AppState> {
  EventRegisterAction(this.id);
  final String id;
  @override
  AppState reduce() {
    final User user = state.userState.user;

    user.events[id] = UserEventState.Attending;
    updateUser(user);

    return null;
  }
}
