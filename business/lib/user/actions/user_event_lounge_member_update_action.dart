import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';

class UserEventLoungeMemberUpdateAction extends ReduxAction<AppState> {
  UserEventLoungeMemberUpdateAction(this._user, this._loungeId, this._eventId);

  final User _user;
  final String _loungeId;
  final String _eventId;

  @override
  AppState reduce() {
    final Map<String, List<Lounge>> eventLounges = state.userState.eventLounges;

    final Lounge lounge = eventLounges[_eventId].firstWhere(
        (Lounge lounge) => lounge.id == _loungeId,
        orElse: () => null);

    if (lounge == null) {
      return null;
    }

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
