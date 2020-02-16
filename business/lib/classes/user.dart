import 'package:cloud_firestore/cloud_firestore.dart';

import 'entity.dart';
import 'interest.dart';

class User extends Entity {
  User({
    String id = '',
    String name = '',
    this.email = '',
    this.home = '',
    GeoPoint location,
    this.birthDate,
    String description = '',
    List<Interest> interests = const <Interest>[],
    this.pics = const <String>[],
    this.facts = const <String>[],
    this.education = '',
    this.profession = '',
  }) : super(
            id: id,
            name: name,
            description: description,
            location: location,
            interests: interests);

  User.fromMap(Map<String, dynamic> snapshot, String id)
      : email = snapshot['email'] as String ?? '',
        home = snapshot['home'] as String ?? '',
        birthDate = snapshot['birthDate'] == null
            ? null
            : (snapshot['birthDate'] as Timestamp).toDate(),
        pics = snapshot['pics'] == null
            ? <String>[]
            : snapshot['pics'].cast<String>() as List<String>,
        facts = snapshot['facts'] == null
            ? <String>[]
            : snapshot['facts'].cast<String>() as List<String>,
        education = snapshot['education'] as String ?? '',
        profession = snapshot['profession'] as String ?? '',
        super(
          id: id ?? '',
          name: snapshot['name'] as String,
          description: snapshot['description'] as String ?? '',
          location: snapshot['location'] as GeoPoint,
          interests: snapshot['interests'] == null
              ? <Interest>[]
              : (snapshot['interests'] as List<dynamic>)
                  .map<Interest>((dynamic interest) => Interest.fromMap(
                      Map<String, String>.from(
                          interest as Map<dynamic, dynamic>)))
                  .toList(),
        );

  String email;
  String home;
  DateTime birthDate;
  List<String> pics;
  List<String> facts;
  String education;
  String profession;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'home': home,
      'location': location,
      'birthDate': Timestamp.fromDate(birthDate),
      'description': description,
      'interests': interests
          .map<Map<String, String>>((Interest interest) => interest.toJson())
          .toList(),
      'pics': pics,
      'facts': facts,
      'education': education,
      'profession': profession,
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
}
