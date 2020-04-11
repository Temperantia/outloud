import 'package:business/classes/user_event_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'entity.dart';

class User extends Entity {
  User(
      {String id = '',
      String name = '',
      this.email = '',
      this.home = '',
      GeoPoint location,
      this.birthDate,
      List<String> interests,
      List<String> pics,
      this.gender = '',
      this.pronoun = '',
      this.orientation = '',
      this.school = '',
      this.degree = '',
      this.position = '',
      this.employer = '',
      List<String> friends,
      List<String> pendingFriends,
      List<String> requestedFriends,
      Map<String, UserEventState> events,
      List<String> lounges,
      List<String> chatIds})
      : pics = pics ?? <String>[],
        friends = friends ?? <String>[],
        pendingFriends = pendingFriends ?? <String>[],
        requestedFriends = requestedFriends ?? <String>[],
        events = events ?? <String, UserEventState>{},
        lounges = lounges ?? <String>[],
        chatIds = chatIds ?? <String>[],
        super(
            id: id,
            name: name,
            location: location,
            interests: interests ?? <String>[]);

  User.fromMap(Map<String, dynamic> snapshot, String id)
      : email = snapshot['email'] as String ?? '',
        home = snapshot['home'] as String ?? '',
        birthDate = snapshot['birthDate'] == null
            ? null
            : (snapshot['birthDate'] as Timestamp).toDate(),
        pics = snapshot['pics'] == null
            ? <String>[]
            : snapshot['pics'].cast<String>() as List<String>,
        gender = snapshot['gender'] as String ?? '',
        pronoun = snapshot['pronoun'] as String ?? '',
        orientation = snapshot['orientation'] as String ?? '',
        school = snapshot['school'] as String ?? '',
        degree = snapshot['degree'] as String ?? '',
        position = snapshot['position'] as String ?? '',
        employer = snapshot['employer'] as String ?? '',
        friends = snapshot['friends'] == null
            ? <String>[]
            : snapshot['friends'].cast<String>() as List<String>,
        pendingFriends = snapshot['pendingFriends'] == null
            ? <String>[]
            : snapshot['pendingFriends'].cast<String>() as List<String>,
        requestedFriends = snapshot['requestedFriends'] == null
            ? <String>[]
            : snapshot['requestedFriends'].cast<String>() as List<String>,
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
        chatIds = snapshot['chatIds'] == null
            ? <String>[]
            : snapshot['chatIds'].cast<String>() as List<String>,
        super(
            id: id ?? '',
            name: snapshot['name'] as String,
            location: snapshot['location'] as GeoPoint,
            interests: snapshot['interests'] == null
                ? <String>[]
                : snapshot['interests'].cast<String>() as List<String>);

  String email;
  String home;
  DateTime birthDate;
  List<String> pics;
  String gender;
  String pronoun;
  String orientation;
  String school;
  String degree;
  String position;
  String employer;
  List<String> friends;
  List<String> pendingFriends;
  List<String> requestedFriends;
  Map<String, UserEventState> events;
  List<String> lounges;
  List<String> chatIds;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'home': home,
      'location': location,
      'birthDate': birthDate == null ? null : Timestamp.fromDate(birthDate),
      'interests': interests,
      'pics': pics,
      'gender': gender,
      'pronoun': pronoun,
      'orientation': orientation,
      'school': school,
      'degree': degree,
      'position': position,
      'employer': employer,
      'friends': friends,
      'pendingFriends': pendingFriends,
      'requestedFriends': requestedFriends,
      'events': events.map<String, String>((String key, UserEventState value) =>
          MapEntry<String, String>(key, EnumToString.parse(value))),
      'lounges': lounges,
      'chatIds': chatIds
    };
  }

  int getAge() {
    if (birthDate == null) {
      return null;
    }

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
