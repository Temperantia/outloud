import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';

class UserFriendsUpdateAction extends ReduxAction<AppState> {
  UserFriendsUpdateAction(this._friends);

  final List<User> _friends;

  @override
  AppState reduce() {
    return state.copy(userState: state.userState.copy(friends: _friends));
  }
}
