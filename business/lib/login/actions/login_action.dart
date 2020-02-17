import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/login/auth.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_update_stream_action.dart';
import 'package:business/user/models/user_state.dart';

// actually initiating the app state
class LoginAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final String id = await login();
    print('logged in');
    UserState.userStream = streamUser(id);
    UserState.userStream
        .listen((User user) => dispatch(UserUpdateStreamAction(user)));

    return state.copy(
        loginState: state.loginState.copy(id: id), loading: false);
  }
}
