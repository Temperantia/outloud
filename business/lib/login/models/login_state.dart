class LoginState {
  LoginState({
    this.id,
    this.loginError,
  });

  LoginState copy({
    String id,
    String loginError,
  }) =>
      LoginState(
        id: id ?? this.id,
        loginError: loginError ?? this.loginError,
      );

  final String id;
  final String loginError;

  static LoginState initialState() {
    return LoginState(
      id: null,
      loginError: '',
    );
  }
}
