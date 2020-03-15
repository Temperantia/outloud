import 'package:business/classes/event.dart';
import 'package:business/classes/lounge_visibility.dart';
import 'package:business/classes/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Lounge {
  Lounge({
    this.id = '',
    this.eventId = '',
    this.eventRef,
    this.name = '',
    this.description = '',
    this.visibility = LoungeVisibility.Public,
    this.location,
    this.date,
    this.owner = '',
    this.memberLimit = 5,
    this.notes,
    this.memberIds = const <String>[],
    this.memberRefs,
    this.members,
  }) {
    members = <User>[];
    if (eventRef != null)
      eventRef.snapshots().listen((DocumentSnapshot doc) =>
          event = Event.fromMap(doc.data, doc.documentID));
    if (memberRefs != null) {
      for (final DocumentReference memberRef in memberRefs) {
        memberRef.snapshots().listen((DocumentSnapshot doc) =>
            members.add(User.fromMap(doc.data, doc.documentID)));
      }
    }
  }

  Lounge.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        eventId = snapshot['eventId'] as String,
        eventRef = snapshot['eventRef'] as DocumentReference,
        name = snapshot['name'] as String ?? '',
        description = snapshot['description'] as String ?? '',
        visibility = snapshot['visibility'] == null
            ? LoungeVisibility.Public
            : EnumToString.fromString(
                LoungeVisibility.values, snapshot['visibility'] as String),
        location = snapshot['location'] as GeoPoint,
        date = snapshot['date'] == null
            ? null
            : (snapshot['date'] as Timestamp).toDate(),
        owner = snapshot['owner'] as String ?? '',
        memberLimit = snapshot['memberLimit'] as int ?? 5,
        notes = snapshot['notes'] as String ?? '',
        memberIds = snapshot['memberIds'] == null
            ? <String>[]
            : snapshot['memberIds'].cast<String>() as List<String>,
        memberRefs = snapshot['memberRefs'] == null
            ? <DocumentReference>[]
            : snapshot['memberRefs'].cast<DocumentReference>()
                as List<DocumentReference>,
        members = <User>[] {
    if (eventRef != null)
      eventRef.snapshots().listen((DocumentSnapshot doc) =>
          event = Event.fromMap(doc.data, doc.documentID));
    if (memberRefs != null) {
      for (final DocumentReference memberRef in memberRefs) {
        memberRef.snapshots().listen((DocumentSnapshot doc) =>
            members.add(User.fromMap(doc.data, doc.documentID)));
      }
    }
  }

  String id;
  String eventId;
  DocumentReference eventRef;
  Event event;
  String name;
  String description;
  LoungeVisibility visibility;
  GeoPoint location;
  DateTime date;
  String owner;
  int memberLimit;
  String notes;
  List<String> memberIds;
  List<DocumentReference> memberRefs;
  List<User> members;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'eventId': eventId,
      'eventRef': eventRef,
      'name': name,
      'description': description,
      'visibility': EnumToString.parse(visibility),
      'location': location,
      'date': date == null ? null : Timestamp.fromDate(date),
      'owner': owner,
      'memberLimit': memberLimit,
      'notes': notes,
      'memberIds': memberIds,
      'memberRefs': memberRefs,
    };
  }

  bool hasUser(String userId) {
    return memberIds.contains(userId);
  }
}
