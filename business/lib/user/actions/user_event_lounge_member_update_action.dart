import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';

class UserEventLoungeMemberUpdateAction extends ReduxAction<AppState> {
  UserEventLoungeMemberUpdateAction(this._user, this.loungeId, this.eventId);

  final User _user;
  final String loungeId;
  final String eventId;

  @override
  AppState reduce() {
    final Map<String, List<Lounge>> eventLounges = state.userState.eventLounges;

    final List<Lounge> lounges = eventLounges[eventId];
    final Lounge lounge =
        lounges.firstWhere((Lounge lounge) => lounge.id == loungeId);
    final int index =
        lounge.members.indexWhere((User member) => member.id == _user.id);
    if (index == -1) {
      lounge.members.add(_user);
    } else {
      lounge.members[index] = _user;
    }

    return state.copy(
        userState: state.userState.copy(eventLounges: eventLounges));
  }
}
