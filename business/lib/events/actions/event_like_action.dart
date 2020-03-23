import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/models/events.dart';

class EventLikeAction extends redux.ReduxAction<AppState> {
  EventLikeAction(this.event);
  final Event event;
  @override
  AppState reduce() {
    event.likes =
        List<String>.from(event.likes + <String>[state.userState.user.id]);
    updateEvent(event);
    return state;
  }
}
