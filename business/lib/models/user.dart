import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

import 'package:business/classes/user.dart';
import 'package:business/models/api.dart';

final Api _api = Api('users');

Future<User> getUser(String id) async {
  final DocumentSnapshot doc = await _api.getDocument(id);
  return doc.data == null ? null : User.fromMap(doc.data, doc.documentID);
}

Stream<User> streamUser(String id) {
  return _api.streamDocument(id).map((final DocumentSnapshot doc) =>
      doc.data == null ? null : User.fromMap(doc.data, doc.documentID));
}

Future<User> getUserWithName(final String name) async {
  final QuerySnapshot snapshot = await _api.queryCollection(
      where: <QueryConstraint>[
        QueryConstraint(field: 'name', isEqualTo: name)
      ]).getDocuments();
  return snapshot.documents.isEmpty
      ? null
      : User.fromMap(
          snapshot.documents[0].data, snapshot.documents[0].documentID);
}

Future<User> getUserWithEmail(final String email) async {
  final QuerySnapshot snapshot = await _api.queryCollection(
      where: <QueryConstraint>[
        QueryConstraint(field: 'email', isEqualTo: email)
      ]).getDocuments();
  return snapshot.documents.isEmpty
      ? null
      : User.fromMap(
          snapshot.documents[0].data, snapshot.documents[0].documentID);
}

Future<List<User>> getUsers(String userId,
    {List<String> interests = const <String>[],
    int ageStart = 13,
    int ageEnd = 99,
    double distance = -1}) async {
  final DateTime now = DateTime.now();
  final DateTime dateStart = DateTime(now.year - ageStart, now.month, now.day);
  final DateTime dateEnd = DateTime(now.year - ageEnd, now.month, now.day);
  Query query = _api.queryCollection(where: <QueryConstraint>[
    QueryConstraint(field: 'birthDate', isGreaterThanOrEqualTo: dateEnd),
    QueryConstraint(field: 'birthDate', isLessThanOrEqualTo: dateStart),
  ]);
  if (interests.isNotEmpty) {
    query = query.where('interests', arrayContainsAny: interests);
  }

  return (await query.getDocuments())
      .documents
      .map((DocumentSnapshot doc) {
        return User.fromMap(doc.data, doc.documentID);
      })
      .where((User user) => user.id != userId)
      .toList();
}

Stream<List<User>> streamUsers({List<String> ids}) {
  if (ids.isEmpty) {
    return Stream<List<User>>.value(<User>[]);
  }
  final Query query =
      _api.queryCollection(field: FieldPath.documentId, whereIn: ids);

  return query.snapshots().map((QuerySnapshot querySnapshot) => querySnapshot
      .documents
      .map<User>(
          (DocumentSnapshot doc) => User.fromMap(doc.data, doc.documentID))
      .toList());
}

Future<void> removeUser(String id) async {
  return _api.removeDocument(id);
}

Future<void> updateUser(User data) async {
  return _api.updateDocument(data.toJson(), data.id);
}

Future<void> updateUserLounge(User user, List<String> lounges) {
  return _api.updateDocument(<String, List<String>>{'lounges': lounges}, user.id);
}

Future<void> updateLocation(GeoPoint location, String userId) async {
  return _api.updateDocument(<String, GeoPoint>{'location': location}, userId);
}

Future<void> createUser(User data) async {
  return _api.createDocument(data.toJson(), data.id);
}

Future<DocumentSnapshot> getPingsFrom(String id, String idSender) {
  return _api.getSubCollectionDocument(id, 'pings', idSender);
}

Future<void> markPingAsRead(String id, String idSender) {
  return _api.removeSubCollectionDocumentById(id, 'pings', idSender);
}

Future<void> ping(String idSender, String idNotified) async {
  final DocumentSnapshot document = await getPingsFrom(idNotified, idSender);
  int pings = 1;
  if (document.data != null) {
    pings += document.data['value'] as int;
  }
  return _api.createDocumentInSubCollection(
      Map<String, dynamic>.from(<String, dynamic>{'value': pings}),
      idNotified,
      'pings',
      idSender);
}
