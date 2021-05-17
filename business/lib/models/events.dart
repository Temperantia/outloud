import 'package:business/classes/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business/models/api.dart';

final Api _api = Api('events');

Stream<Event> streamEvent(String id) {
  return _api
      .streamDocument(id)
      .map((DocumentSnapshot doc) => Event.fromMap(doc.data, doc.documentID));
}

Stream<List<Event>> streamEvents(List<String> ids) {
  if (ids.isEmpty) {
    return Stream<List<Event>>.value(<Event>[]);
  }
  for (int i = 0; i < ids.length; i += 10) {
    _api
        .queryCollection(
            field: FieldPath.documentId,
            whereIn: ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10))
        .snapshots();
  }

  return _api
      .queryCollection(field: FieldPath.documentId, whereIn: ids)
      .snapshots()
      .map<List<Event>>((QuerySnapshot querySnapshot) {
    return querySnapshot.documents
        .map<Event>(
            (DocumentSnapshot doc) => Event.fromMap(doc.data, doc.documentID))
        .toList();
  });
}

Future<List<Event>> getEvents() async {
  final Query query = _api.queryCollection();

  return (await query.getDocuments())
      .documents
      .map((DocumentSnapshot doc) => Event.fromMap(doc.data, doc.documentID))
      .toList();
}

Future<Event> createEvent() async {
  return Event(id: (await _api.addDocument(<String, dynamic>{})).documentID);
}

Future<void> updateEvent(Event event) async {
  return _api.updateDocument(event.toJson(), event.id);
}
