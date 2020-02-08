import 'package:business/login/models/login_state.dart';

class AppState {
  AppState({
    this.loginState,
  });
  AppState copy({LoginState loginState}) => AppState(
        loginState: loginState ?? this.loginState,
      );

  final LoginState loginState;

  static AppState initialState() =>
      AppState(loginState: LoginState.initialState());
}
