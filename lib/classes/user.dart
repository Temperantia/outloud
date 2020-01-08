import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/ping.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/user.dart';

class User extends Entity {
  User(
      {this.id,
      String name,
      this.email,
      this.location,
      this.birthDate,
      this.description,
      this.interests,
      this.pics})
      : super(name);

  User.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        email = snapshot['email'] as String ?? '',
        location = snapshot['location'] as String ?? '',
        birthDate =
            (snapshot['birthDate'] as Timestamp).toDate() ?? DateTime.now(),
        description = snapshot['description'] as String ?? '',
        interests = snapshot['interests'] as List<dynamic> ?? <dynamic>[],
        pics = snapshot['pics'] as List<dynamic> ?? <dynamic>[],
        super(snapshot['name'] as String);

  final UserModel userProvider = locator<UserModel>();
  final String id;
  String email;
  String location;
  DateTime birthDate;
  String description;
  List<dynamic> interests; // TODO(nadir): list of string doesnt work, .
  List<dynamic> pics; // TODO(nadir): list of string doesnt work, .
  List<Ping> pings = <Ping>[];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
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
    return userProvider.streamPings(id);
  }
}
