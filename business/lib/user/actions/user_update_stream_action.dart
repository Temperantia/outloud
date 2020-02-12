import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';

class UserUpdateStreamAction extends ReduxAction<AppState> {
  UserUpdateStreamAction(this.user);

  final User user;

  @override
  AppState reduce() {
    return state.copy(userState: state.userState.copy(user: user));
  }
}
