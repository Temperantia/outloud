class LoginState {
  LoginState({
    this.connected,
    this.loginError,
  });

  LoginState copy({
    bool connected,
    String loginError,
  }) =>
      LoginState(
        connected: connected ?? this.connected,
        loginError: loginError ?? this.loginError,
      );

  final bool connected;
  final String loginError;

  static LoginState initialState() => LoginState(
        connected: false,
        loginError: '',
      );
}
