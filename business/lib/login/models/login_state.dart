class LoginState {
  LoginState({
    this.connected,
    this.id,
    this.loginError,
  });

  LoginState copy({
    bool connected,
    String id,
    String loginError,
  }) =>
      LoginState(
        connected: connected ?? this.connected,
        id: id ?? this.id,
        loginError: loginError ?? this.loginError,
      );

  final bool connected;
  final String id;
  final String loginError;

  static LoginState initialState() {
    return LoginState(
      connected: false,
      id: null,
      loginError: '',
    );
  }
}
