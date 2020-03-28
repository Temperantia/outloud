import 'package:business/classes/user.dart';

class PeopleState {
  PeopleState({this.people, this.distances});

  PeopleState copy({List<User> people, Map<String, String> distances}) =>
      PeopleState(
          people: people ?? this.people,
          distances: distances ?? this.distances);

  final List<User> people;
  final Map<String, String> distances;

  static PeopleState initialState() => PeopleState();
}
