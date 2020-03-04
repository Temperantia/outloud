import 'package:cloud_firestore/cloud_firestore.dart';

class Lounge {
  Lounge({
    this.id = '',
    this.name = '',
    this.description = '',
    this.isPublic = true,
    this.location,
    this.date,
    this.owner = '',
    this.memberLimit = 5,
    this.memberIds = const <String>[],
  });

  Lounge.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] as String ?? '',
        description = snapshot['description'] as String ?? '',
        isPublic = snapshot['isPublic'] as bool ?? true,
        location = snapshot['location'] as GeoPoint,
        date = snapshot['date'] == null
            ? null
            : (snapshot['date'] as Timestamp).toDate(),
            owner = snapshot['owner'] as String ?? '',
        memberLimit = snapshot['memberLimit'] as int ?? 5,
        memberIds = snapshot['memberIds'] == null
            ? <String>[]
            : snapshot['memberIds'].cast<String>() as List<String>;

  String id;
  String name;
  String description;
  bool isPublic;
  GeoPoint location;
  DateTime date;
  String owner;
  int memberLimit;
  List<String> memberIds;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'isPublic': isPublic,
      'location': location,
      'date': date == null ? null : Timestamp.fromDate(date),
      'owner': owner,
      'memberLimit': memberLimit,
      'memberIds': memberIds,
    };
  }

  bool hasUser(String userId) {
    return memberIds.contains(userId);
  }
}
