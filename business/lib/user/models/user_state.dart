import 'package:business/classes/user.dart';

class UserState {
  UserState({
    this.user,
    this.friends,
  });

  UserState copy({
    User user,
    List<User> friends,
  }) =>
      UserState(
        user: user ?? this.user,
        friends: friends ?? this.friends,
      );

  final User user;
  final List<User> friends;
  static Stream<User> userStream;

  static UserState initialState() => UserState();
}
