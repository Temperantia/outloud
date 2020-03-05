import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';

class UserState {
  UserState({
    this.user,
    this.friends,
    this.events,
    this.lounges,
  });

  UserState copy({
    User user,
    List<User> friends,
    List<Event> events,
    List<Lounge> lounges,
  }) =>
      UserState(
        user: user ?? this.user,
        friends: friends ?? this.friends,
        events: events ?? this.events,
        lounges: lounges ?? this.lounges,
      );

  final User user;
  final List<User> friends;
  final List<Event> events;
  final List<Lounge> lounges;
  static Stream<User> userStream;
  static Stream<List<Event>> eventsStream;

  static UserState initialState() => UserState();
}
