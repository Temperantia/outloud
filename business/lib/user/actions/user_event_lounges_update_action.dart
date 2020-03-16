import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';

class UserEventLoungesUpdateAction extends redux.ReduxAction<AppState> {
  UserEventLoungesUpdateAction(this.lounges);

  final List<Lounge> lounges;

  @override
  AppState reduce() {
    final Map<String, List<Lounge>> eventLounges = <String, List<Lounge>>{};
    for (final Lounge lounge in lounges) {
      final List<Lounge> eventLounge = eventLounges[lounge.eventId];
      if (eventLounge == null) {
        eventLounges[lounge.eventId] = <Lounge>[lounge];
      } else {
        eventLounges[lounge.eventId].add(lounge);
      }
    }
    return state.copy(
        userState: state.userState.copy(eventLounges: eventLounges));
  }
}
