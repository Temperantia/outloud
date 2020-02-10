import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class LoginEmailAction extends ReduxAction<AppState> {
  LoginEmailAction();

  @override
  Future<AppState> reduce() async {
    return state.copy(loginState: state.loginState.copy(connected: true));
  }
}
