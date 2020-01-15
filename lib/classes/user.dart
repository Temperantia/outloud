import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/ping.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/user.dart';

class User extends Entity {
  User({
    this.id = '',
    String name,
    this.email,
    this.home,
    this.location,
    this.birthDate,
    this.description,
    this.interests,
    this.pics,
    this.motto,
    this.scholarship,
    this.businessTitle,
  }) : super(name);

  User.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        email = snapshot['email'] as String ?? '',
        home = snapshot['home'] as String ?? '',
        location = snapshot['location'] as GeoPoint,
        birthDate = (snapshot['birthDate'] as Timestamp).toDate(),
        description = snapshot['description'] as String ?? '',
        interests = snapshot['interests'] == null
            ? <String>[]
            : snapshot['interests'].cast<String>() as List<String>,
        pics = snapshot['pics'] == null
            ? <dynamic>[]
            : snapshot['pics'] as List<dynamic>,
        motto = snapshot['motto'] as String ?? '',
        scholarship = snapshot['scholarship'] as String ?? '',
        businessTitle = snapshot['businessTitle'] as String ?? '',
        super(snapshot['name'] as String);

  final String id;
  String email = '';
  String home = '';
  GeoPoint location;
  DateTime birthDate;
  String description = '';
  List<String> interests = <String>[];
  List<dynamic> pics = <dynamic>[];
  String motto = '';
  String scholarship = '';
  String businessTitle = '';

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
      'motto': motto,
      'scholarship': scholarship,
      'businessTitle': businessTitle,
    };
  }

  int getAge() {
    final DateTime currentDate = DateTime.now();
    final int month1 = currentDate.month;
    final int month2 = birthDate.month;

    int age = currentDate.year - birthDate.year;
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
