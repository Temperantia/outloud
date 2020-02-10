import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/auth.dart';

class LoginAction extends ReduxAction<AppState> {
  LoginAction();

  @override
  Future<AppState> reduce() async {
    final bool connected = await login(dispatch);
    return state.copy(
        loginState: state.loginState.copy(connected: connected),
        loading: false);
  }
}
