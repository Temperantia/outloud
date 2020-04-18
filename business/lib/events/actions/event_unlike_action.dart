import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';

class EventUnlikeAction extends ReduxAction<AppState> {
  EventUnlikeAction(this._event);
  final Event _event;
  @override
  AppState reduce() {
    updateUser(state.userState.user..events.remove(_event.id));

    updateEvent(_event..likes.remove(state.userState.user.id));

    return null;
  }
}
