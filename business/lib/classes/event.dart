import 'package:cloud_firestore/cloud_firestore.dart';

import 'entity.dart';
import 'interest.dart';

class Event extends Entity {
  Event({
    String id = '',
    String name = '',
    String description = '',
    GeoPoint location,
    List<Interest> interests = const <Interest>[],
    this.owner = '',
    this.adminIds = const <String>[],
    this.memberIds = const <String>[],
    this.pic = '',
  }) : super(
          id: id,
          name: name,
          description: description,
          location: location,
          interests: interests,
        );

  Event.fromMap(Map<String, dynamic> snapshot, String id)
      : owner = snapshot['owner'] as String ?? '',
        adminIds = snapshot['adminIds'] == null
            ? <String>[]
            : snapshot['adminIds'].cast<String>() as List<String>,
        memberIds = snapshot['memberIds'] == null
            ? <String>[]
            : snapshot['memberIds'].cast<String>() as List<String>,
        pic = snapshot['pic'] as String ?? '',
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
                  .toList(),
        );

  String owner;
  List<String> adminIds;
  List<String> memberIds;
  String pic;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'location': location,
      'interests': interests
          .map<Map<String, String>>((Interest interest) => interest.toJson())
          .toList(),
      'owner': owner,
      'adminIds': adminIds,
      'memberIds': memberIds,
      'pic': pic,
    };
  }

  bool hasUser(String userId) {
    return memberIds.contains(userId);
  }
}
