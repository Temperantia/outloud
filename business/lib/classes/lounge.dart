import 'package:business/classes/entity.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:business/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Lounge extends Entity {
  Lounge(
      {String id = '',
      this.eventId = '',
      String name = '',
      String description = '',
      this.visibility = LoungeVisibility.Public,
      GeoPoint location,
      this.date,
      this.owner = '',
      this.memberLimit = 5,
      this.notes,
      List<String> memberIds,
      this.members})
      : memberIds = memberIds ?? <String>[],
        super(id: id, name: name, description: description, location: location);

  Lounge.fromMap(Map<String, dynamic> snapshot, String id)
      : eventId = snapshot['eventId'] as String,
        visibility = snapshot['visibility'] == null
            ? LoungeVisibility.Public
            : EnumToString.fromString(
                LoungeVisibility.values, snapshot['visibility'] as String),
        date = snapshot['date'] == null
            ? null
            : (snapshot['date'] as Timestamp).toDate(),
        owner = snapshot['owner'] as String ?? '',
        memberLimit = snapshot['memberLimit'] as int ?? 5,
        notes = snapshot['notes'] as String ?? '',
        memberIds = snapshot['memberIds'] == null
            ? <String>[]
            : List<String>.of(snapshot['memberIds'].cast<String>() as List<String>),
        members = <User>[],
        super(
            id: id ?? '',
            name: snapshot['name'] as String ?? '',
            description: snapshot['description'] as String ?? '',
            location: snapshot['location'] as GeoPoint);

  String eventId;
  Event event;
  LoungeVisibility visibility;
  DateTime date;
  String owner;
  int memberLimit;
  String notes;
  List<String> memberIds;
  List<User> members;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'eventId': eventId,
        'name': name,
        'description': description,
        'visibility': EnumToString.parse(visibility),
        'location': location,
        'date': date == null ? null : Timestamp.fromDate(date),
        'owner': owner,
        'memberLimit': memberLimit,
        'notes': notes,
        'memberIds': memberIds
      };

  bool hasUser(String userId) => memberIds.contains(userId);
}
