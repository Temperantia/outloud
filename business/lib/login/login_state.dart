import 'package:business/classes/user.dart';

class LoginState {
  LoginState({this.id, this.user, this.loginError});

  LoginState copy({String id, User user, String loginError}) => LoginState(
      id: id ?? this.id,
      user: user ?? this.user,
      loginError: loginError ?? this.loginError);

  final String id;
  final User user;
  final String loginError;

  static LoginState initialState() => LoginState(loginError: '');
}
