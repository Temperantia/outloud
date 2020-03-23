import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';

class EventUnlikeAction extends redux.ReduxAction<AppState> {
  EventUnlikeAction(this.event);
  final Event event;
  @override
  AppState reduce() {
    final List<String> likes = List<String>.from(event.likes);
    likes.remove(state.userState.user.id);
    event.likes = likes;
    updateEvent(event);

    return state;
  }
}
