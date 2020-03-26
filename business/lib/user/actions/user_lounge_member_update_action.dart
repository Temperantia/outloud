import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';

class UserLoungeMemberUpdateAction extends ReduxAction<AppState> {
  UserLoungeMemberUpdateAction(this.user, this.loungeId);

  final User user;
  final String loungeId;

  @override
  AppState reduce() {
    final List<Lounge> lounges = state.userState.lounges;
    final Lounge lounge =
        lounges.firstWhere((Lounge lounge) => lounge.id == loungeId);
    lounge.members.add(user);
    return state.copy(userState: state.userState.copy(lounges: lounges));
  }
}
