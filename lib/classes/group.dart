import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inclusive/classes/entity.dart';
import 'package:inclusive/classes/interest.dart';

class Group extends Entity {
  Group({
    String id = '',
    String name = '',
    String description = '',
    GeoPoint location,
    List<Interest> interests = const <Interest>[],
    this.owner = '',
    this.adminIds,
    this.memberIds,
  }) : super(
          id: id,
          name: name,
          description: description,
          location: location,
          interests: interests,
        );

  Group.fromMap(Map<String, dynamic> snapshot, String id)
      : owner = snapshot['owner'] as String ?? '',
        adminIds = snapshot['adminIds'] as List<String> ?? <String>[],
        memberIds = snapshot['memberIds'] as List<String> ?? <String>[],
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
    };
  }

  bool hasUser(String userId) {
    return memberIds.contains(userId);
  }
}
