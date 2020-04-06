import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';

class UserState {
  UserState(
      {this.user, this.friends, this.pendingFriends, this.events, this.eventLounges, this.lounges});

  UserState copy(
          {User user,
          List<User> friends,
          List<User> pendingFriends,
          List<Event> events,
          Map<String, List<Lounge>> eventLounges,
          List<Lounge> lounges}) =>
      UserState(
          user: user ?? this.user,
          friends: friends ?? this.friends,
          pendingFriends: pendingFriends ?? this.pendingFriends,
          events: events ?? this.events,
          eventLounges: eventLounges ?? this.eventLounges,
          lounges: lounges ?? this.lounges);

  final User user;
  final List<User> friends;
  final List<User> pendingFriends;
  final List<Event> events;
  final Map<String, List<Lounge>> eventLounges;
  final List<Lounge> lounges;

  static UserState initialState() => UserState();
}
