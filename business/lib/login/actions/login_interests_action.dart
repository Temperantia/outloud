import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';

class LoginInterestsAction extends ReduxAction<AppState> {
  LoginInterestsAction(this._interests);

  final List<String> _interests;

  @override
  AppState reduce() {
    return state.copy(
        loginState: state.loginState
            .copy(user: state.loginState.user..interests = _interests));
  }
}
