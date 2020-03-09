import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class UserEventLoungesUpdateAction extends redux.ReduxAction<AppState> {
  UserEventLoungesUpdateAction(this.lounges);
  final List<Lounge> lounges;

  @override
  AppState reduce() {
    Map<String, List<Lounge>> eventLounges = {};
    for (var lounge in lounges) {
      var eventLounge = eventLounges[lounge.eventId];
      if (eventLounge == null) {
        eventLounges[lounge.eventId] = [lounge];
      } else {
        eventLounges[lounge.eventId].add(lounge);
      }
    }
    return state.copy(
        userState: state.userState.copy(eventLounges: eventLounges));
  }
}
