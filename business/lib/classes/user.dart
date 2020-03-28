import 'package:business/classes/user_event_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'entity.dart';
import 'interest.dart';

class User extends Entity {
  User(
      {String id = '',
      String name = '',
      this.email = '',
      this.home = '',
      GeoPoint location,
      this.birthDate,
      String description = '',
      List<Interest> interests = const <Interest>[],
      this.pics = const <String>[],
      this.facts = const <String>[],
      this.gender = '',
      this.pronoun = '',
      this.orientation = '',
      this.education = '',
      this.profession = '',
      this.friends = const <String>[],
      this.events = const <String, UserEventState>{},
      this.lounges = const <String>[]})
      : super(
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
        gender = snapshot['gender'] as String ?? '',
        pronoun = snapshot['pronoun'] as String ?? '',
        orientation = snapshot['orientation'] as String ?? '',
        education = snapshot['education'] as String ?? '',
        profession = snapshot['profession'] as String ?? '',
        friends = snapshot['friends'] == null
            ? <String>[]
            : snapshot['friends'].cast<String>() as List<String>,
        events = snapshot['events'] == null
            ? <String, UserEventState>{}
            : Map<String, String>.from(
                    snapshot['events'] as Map<dynamic, dynamic>)
                .map<String, UserEventState>((String key, String value) =>
                    MapEntry<String, UserEventState>(key,
                        EnumToString.fromString(UserEventState.values, value))),
        lounges = snapshot['lounges'] == null
            ? <String>[]
            : snapshot['lounges'].cast<String>() as List<String>,
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
                    .toList());

  String email;
  String home;
  DateTime birthDate;
  List<String> pics;
  List<String> facts;
  String gender;
  String pronoun;
  String orientation;
  String education;
  String profession;
  List<String> friends;
  Map<String, UserEventState> events;
  List<String> lounges;

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
      'gender': gender,
      'pronoun': pronoun,
      'orientation': orientation,
      'education': education,
      'profession': profession,
      'friends': friends,
      'events': events.map<String, String>((String key, UserEventState value) =>
          MapEntry<String, String>(key, EnumToString.parse(value))),
      'lounges': lounges
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

  bool isAttendingEvent(String id) =>
      events.containsKey(id) && events[id] == UserEventState.Attending;
}
