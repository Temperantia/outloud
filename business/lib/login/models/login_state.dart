class LoginState {
  LoginState({this.connected});
  LoginState copy({bool connected}) => LoginState(
        connected: connected ?? this.connected,
      );

  final bool connected;

  static LoginState initialState() => LoginState(connected: false);
}
