import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class LoginErrorAction extends ReduxAction<AppState> {
  LoginErrorAction(this.message);

  String message;

  @override
  AppState reduce() {
    return state.copy(loginState: state.loginState.copy(loginError: message));
  }
}
