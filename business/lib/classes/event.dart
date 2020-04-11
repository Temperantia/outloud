import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'entity.dart';

class Event extends Entity {
  Event(
      {String id = '',
      String name = '',
      String description = '',
      GeoPoint location,
      List<String> interests,
      this.dateStart,
      this.dateEnd,
      List<String> memberIds,
      List<String> likes,
      this.pic,
      this.price = ''})
      : memberIds = memberIds ?? <String>[],
        likes = likes ?? <String>[],
        super(
            id: id,
            name: name,
            description: description,
            location: location,
            interests: interests ?? <String>[]);

  Event.fromMap(Map<String, dynamic> snapshot, String id)
      : dateStart = snapshot['dateStart'] == null
            ? null
            : (snapshot['dateStart'] as Timestamp).toDate(),
        dateEnd = snapshot['dateEnd'] == null
            ? null
            : (snapshot['dateEnd'] as Timestamp).toDate(),
        memberIds = snapshot['memberIds'] == null
            ? <String>[]
            : List<String>.of(snapshot['memberIds'].cast<String>() as List<String>, growable: true),
        likes = snapshot['likes'] == null
            ? <String>[]
            : List<String>.of(snapshot['likes'].cast<String>() as List<String>, growable: true),
        pic = snapshot['pic'] as String,
        price = snapshot['price'] as String ?? '',
        super(
            id: id ?? '',
            name: snapshot['name'] as String ?? '',
            description: snapshot['description'] as String ?? '',
            location: snapshot['location'] as GeoPoint,
            interests: snapshot['interests'] == null
                ? <String>[]
                : List<String>.of(snapshot['interests'].cast<String>() as List<String>, growable: true));

  DateTime dateStart;
  DateTime dateEnd;
  List<String> memberIds;
  List<String> likes;
  String pic;
  String price;

  double distance;
  List<User> members;
  List<Message> messages;
  List<User> chatMembers;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
        'location': location,
        'interests': interests,
        'dateStart': dateStart == null ? null : Timestamp.fromDate(dateStart),
        'dateEnd': dateEnd == null ? null : Timestamp.fromDate(dateEnd),
        'memberIds': memberIds,
        'likes': likes,
        'pic': pic,
        'price': price
      };

  bool hasUser(String userId) => memberIds.contains(userId);
}
