import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/events.dart';
import 'package:business/models/lounges.dart';
import 'package:business/user/actions/user_events_update_action.dart';
import 'package:business/user/actions/user_lounges_update_action.dart';

class UserUpdateStreamAction extends redux.ReduxAction<AppState> {
  UserUpdateStreamAction(this.user);

  final User user;

  @override
  AppState reduce() {
    streamEvents(user.events.keys.toList()).listen(
        (List<Event> events) => dispatch(UserEventsUpdateAction(events)));
    streamLounges(ids: user.events.keys.toList()).listen(
        (List<Lounge> lounges) => dispatch(UserLoungesUpdateAction(lounges)));
    return state.copy(userState: state.userState.copy(user: user));
  }
}
