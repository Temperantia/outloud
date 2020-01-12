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
      this.home,
      this.location,
      this.birthDate,
      this.description,
      this.interests,
      this.pics})
      : super(name);

  User.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        email = snapshot['email'] as String ?? '',
        home = snapshot['home'] as String ?? '',
        location = snapshot['location'] as GeoPoint,
        birthDate =
            (snapshot['birthDate'] as Timestamp).toDate() ?? DateTime.now(),
        description = snapshot['description'] as String ?? '',
        interests = snapshot['interests'] == null
            ? <String>[]
            : snapshot['interests'].cast<String>() as List<String>,
        pics = snapshot['interests'] == null
            ? <String>[]
            : snapshot['interests'].cast<String>() as List<String>,
        super(snapshot['name'] as String);

  final String id;
  String email;
  String home;
  GeoPoint location;
  DateTime birthDate;
  String description;
  List<String> interests;
  List<String> pics;

  final UserModel _userProvider = locator<UserModel>();

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'home': home,
      'location': location,
      'birthDate': birthDate,
      'description': description,
      'interests': interests,
      'pics': pics,
    };
  }

  int getAge() {
    final DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    final int month1 = currentDate.month;
    final int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      final int day1 = currentDate.day;
      final int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Stream<List<Ping>> streamPings() {
    return _userProvider.streamPings(id);
  }
}
