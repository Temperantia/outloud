import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';

class EventUnlikeAction extends redux.ReduxAction<AppState> {
  EventUnlikeAction(this._event);
  final Event _event;
  @override
  AppState reduce() {
    updateUser(state.userState.user..events.remove(_event.id));

    final List<String> likes = List<String>.from(_event.likes)
      ..remove(state.userState.user.id);
    _event.likes = likes;
    updateEvent(_event..likes);

    return null;
  }
}
