import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class LoginEmailAction extends ReduxAction<AppState> {
  LoginEmailAction();

  @override
  AppState reduce() {
    return state.copy(loginState: state.loginState.copy(connected: true));
  }
}
