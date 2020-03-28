import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';

class UserLoungeMemberUpdateAction extends ReduxAction<AppState> {
  UserLoungeMemberUpdateAction(this._user, this._loungeId);

  final User _user;
  final String _loungeId;

  @override
  AppState reduce() {
    final List<Lounge> lounges = state.userState.lounges;

    final Lounge lounge = lounges.firstWhere(
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

    return state.copy(userState: state.userState.copy(lounges: lounges));
  }
}
