import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class LoginErrorAction extends ReduxAction<AppState> {
  LoginErrorAction(this.message);

  String message;

  @override
  Future<AppState> reduce() async {
    return state.copy(loginState: state.loginState.copy(loginError: message));
  }
}
