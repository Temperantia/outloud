import 'package:business/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'entity.dart';
import 'interest.dart';

class Event extends Entity {
  Event(
      {String id = '',
      String name = '',
      String description = '',
      GeoPoint location,
      List<Interest> interests = const <Interest>[],
      this.dateStart,
      this.dateEnd,
      this.adminIds = const <String>[],
      this.memberIds = const <String>[],
      this.likes = const <String>[],
      this.pic,
      this.price = ''})
      : super(
            id: id,
            name: name,
            description: description,
            location: location,
            interests: interests);

  Event.fromMap(Map<String, dynamic> snapshot, String id)
      : dateStart = snapshot['dateStart'] == null
            ? null
            : (snapshot['dateStart'] as Timestamp).toDate(),
        dateEnd = snapshot['dateEnd'] == null
            ? null
            : (snapshot['dateEnd'] as Timestamp).toDate(),
        adminIds = snapshot['adminIds'] == null
            ? <String>[]
            : snapshot['adminIds'].cast<String>() as List<String>,
        memberIds = snapshot['memberIds'] == null
            ? <String>[]
            : snapshot['memberIds'].cast<String>() as List<String>,
        likes = snapshot['likes'] == null
            ? <String>[]
            : snapshot['likes'].cast<String>() as List<String>,
        pic = snapshot['pic'] as String,
        price = snapshot['price'] as String ?? '',
        super(
            id: id ?? '',
            name: snapshot['name'] as String ?? '',
            description: snapshot['description'] as String ?? '',
            location: snapshot['location'] as GeoPoint,
            interests: snapshot['interests'] == null
                ? <Interest>[]
                : (snapshot['interests'] as List<dynamic>)
                    .map<Interest>((dynamic interest) => Interest.fromMap(
                        Map<String, String>.from(
                            interest as Map<dynamic, dynamic>)))
                    .toList());

  DateTime dateStart;
  DateTime dateEnd;
  List<String> adminIds;
  List<String> memberIds;
  List<String> likes;
  String pic;
  String price;

  double distance;
  List<User> members;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
        'location': location,
        'interests': interests
            .map<Map<String, String>>((Interest interest) => interest.toJson())
            .toList(),
        'dateStart': dateStart == null ? null : Timestamp.fromDate(dateStart),
        'dateEnd': dateEnd == null ? null : Timestamp.fromDate(dateEnd),
        'adminIds': adminIds,
        'memberIds': memberIds,
        'likes': likes,
        'pic': pic,
        'price': price
      };

  bool hasUser(String userId) => memberIds.contains(userId);
}
