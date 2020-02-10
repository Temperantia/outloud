import 'package:business/classes/user.dart';

class UserState {
  UserState({
    this.user,
  });

  UserState copy({
    User user,
  }) =>
      UserState(
        user: user ?? this.user,
      );

  final User user;
  static Stream<User> userStream;

  static UserState initialState() => UserState();
}
