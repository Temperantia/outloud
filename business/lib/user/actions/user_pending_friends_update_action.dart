import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';

class UserPendingFriendsUpdateAction extends redux.ReduxAction<AppState> {
  UserPendingFriendsUpdateAction(this._pendingFriends);

  final List<User> _pendingFriends;

  @override
  AppState reduce() {
    return state.copy(userState: state.userState.copy(pendingFriends: _pendingFriends));
  }
}
