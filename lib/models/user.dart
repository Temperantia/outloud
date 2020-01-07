import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/classes/ping.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/api.dart';

class UserModel extends ChangeNotifier {
  Api _api = locator<Api>('users');

  Future<User> getUser(String id) async {
    DocumentSnapshot doc = await _api.getDocument(id);
    return doc.data == null ? null : User.fromMap(doc.data, doc.documentID);
  }

  Stream<User> streamUser(String id) {
    return _api.streamDocument(id).map((DocumentSnapshot doc) {
      return doc.data == null ? null : User.fromMap(doc.data, doc.documentID);
    });
  }

  Future<User> getUserWithName(String name) async {
    final QuerySnapshot snapshot = await _api.queryCollection(where: [
      QueryConstraint(field: 'name', isEqualTo: name)
    ]).getDocuments();
    return snapshot.documents.isEmpty
        ? null
        : User.fromMap(
            snapshot.documents[0].data, snapshot.documents[0].documentID);
  }

  Future<User> getUserWithEmail(String email) async {
    final QuerySnapshot snapshot = await _api.queryCollection(where: [
      QueryConstraint(field: 'email', isEqualTo: email)
    ]).getDocuments();
    return snapshot.documents.isEmpty
        ? null
        : User.fromMap(
            snapshot.documents[0].data, snapshot.documents[0].documentID);
  }

  Future<List<User>> getUsers(
      {List<String> interests = const [],
      int ageStart = 13,
      int ageEnd = 99,
      double distance = -1}) async {
    DateTime now = DateTime.now();
    DateTime dateStart = DateTime(now.year - ageStart, now.month, now.day);
    DateTime dateEnd = DateTime(now.year - ageEnd, now.month, now.day);

    return (await _api.queryCollection(where: [
      QueryConstraint(field: 'birthDate', isGreaterThanOrEqualTo: dateEnd),
      QueryConstraint(field: 'birthDate', isLessThanOrEqualTo: dateStart)
    ]).getDocuments())
        .documents
        .map((doc) => User.fromMap(doc.data, doc.documentID))
        .toList();
  }

  Future removeUser(String id) async {
    _api.removeDocument(id);
  }

  Future updateUser(User data) async {
    _api.updateDocument(data.toJson(), data.id);
  }

  Future createUser(User data) async {
    return _api.createDocument(data.toJson(), data.id);
  }

  Stream<List<Ping>> streamPings(String id) {
    return getDataFromQuery(
        query: _api.querySubCollection(id, 'pings'),
        mapper: (final DocumentSnapshot messageDoc) =>
            Ping.fromMap(messageDoc.data, messageDoc.documentID));
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
      pings += document.data['value'];
    }
    _api.createDocumentInSubCollection(
        Map<String, dynamic>.from({'value': pings}),
        idNotified,
        'pings',
        idSender);
  }
}
