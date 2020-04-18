import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/user.dart';
import 'package:business/classes/user_event_state.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';

class EventLikeAction extends ReduxAction<AppState> {
  EventLikeAction(this._event);

  final Event _event;

  @override
  AppState reduce() {
    final User user = state.userState.user;

    user.events[_event.id] = UserEventState.Liked;
    updateUser(user);

    updateEvent(_event..likes.add(state.userState.user.id));
    return null;
  }
}
