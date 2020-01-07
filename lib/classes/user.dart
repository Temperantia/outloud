import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/ping.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/user.dart';

class User implements Entity {
  final UserModel userProvider = locator<UserModel>();
  String id;
  String name;
  String email;
  String location;
  DateTime birthDate;
  String description;
  List interests;
  List pics;
  List<Ping> pings = [];

  User({this.id, this.name, this.email, this.birthDate});

  User.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        location = snapshot['location'] ?? '',
        birthDate = snapshot['birthDate'].toDate() ?? DateTime.now(),
        description = snapshot['description'] ?? '',
        interests = snapshot['interests'] ?? [],
        pics = snapshot['pics'] ?? [];

  toJson() {
    return {
      'name': name,
      'email': email,
      'location': location,
      'birthDate': birthDate,
      'description': description,
      'interests': interests,
      'pics': pics,
    };
  }

  int getAge() {
    return DateTime.now().year - birthDate.year;
  }

  Stream<List<Ping>> streamPings() {
    Stream<List<Ping>> stream = userProvider.streamPings(id);
    return stream;
  }
}