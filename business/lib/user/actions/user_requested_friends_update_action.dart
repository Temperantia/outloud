import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';

class UserRequestedFriendsUpdateAction extends ReduxAction<AppState> {
  UserRequestedFriendsUpdateAction(this._requestedFriends);

  final List<User> _requestedFriends;

  @override
  AppState reduce() {
    return state.copy(
        userState: state.userState.copy(requestedFriends: _requestedFriends));
  }
}
