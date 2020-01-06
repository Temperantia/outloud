import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/api.dart';

class Ping {
  String id;
  int value;

  Ping.fromMap(Map snapshot, String id)
      : id = id ?? '',
        value = snapshot['value'] ?? 0;

  toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}

class User {
  final UserModel userProvider = locator<UserModel>();
  String id;
  String name;
  String email;
  String location;
  DateTime birthDate;
  String description;
  List interests;
  String pics;
  List<Ping> pings = [];

  User({this.id, this.name, this.email, this.birthDate});

  User.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        location = snapshot['location'] ?? '',
        birthDate = snapshot['birthDate'].toDate() ?? null,
        description = snapshot['description'] ?? '',
        interests = snapshot['interests'] ?? [],
        pics = snapshot['pics'] ?? '';

  toJson() {
    return {
      'name': name,
      'email': email,
      'location': location,
      'birthDate': birthDate,
      'description': description,
      'interests': interests,
      'pics': pics,
    };
  }

  int getAge() {
    return DateTime.now().year - birthDate.year;
  }

  Stream<List<Ping>> streamPings() {
    Stream<List<Ping>> stream = userProvider.streamPings(id);
    stream.listen((final List<Ping> pings) {
      this.pings = pings;
    });
    return stream;
  }
}

class UserModel extends ChangeNotifier {
  Api _api = locator<Api>('users');

  Future<User> getUser(String id) async {
    DocumentSnapshot doc = await _api.getDocumentById(id);
    return doc.data == null ? null : User.fromMap(doc.data, doc.documentID);
  }

  Stream<User> streamUser(String id) {
    return _api.streamDocumentById(id).map((DocumentSnapshot doc) {
      return doc.data == null ? null : User.fromMap(doc.data, doc.documentID);
    });
  }

  Future<User> getUserWithName(String name) async {
    var snapshot = await _api.getDocumentsByField('name', name);
    return snapshot.documents.isEmpty
        ? null
        : User.fromMap(
            snapshot.documents[0].data, snapshot.documents[0].documentID);
  }

  Future<User> getUserWithEmail(String email) async {
    var snapshot = await _api.getDocumentsByField('email', email);
    return snapshot.documents.isEmpty
        ? null
        : User.fromMap(
            snapshot.documents[0].data, snapshot.documents[0].documentID);
  }

  Future<List<User>> getUsers({List<String> interests = const [], int ageStart = 13, int ageEnd = 99, double distance = -1}) async {
    DateTime now = DateTime.now();
    DateTime dateStart = DateTime(now.year - ageStart, now.month, now.day);
    DateTime dateEnd = DateTime(now.year - ageEnd, now.month, now.day);

    return (await _api.streamDataCollection(where:[
      QueryConstraint(field: 'birthDate', isGreaterThanOrEqualTo: dateEnd),
      QueryConstraint(field: 'birthDate', isLessThanOrEqualTo: dateStart)
    ]).getDocuments()).documents.map((doc) => User.fromMap(doc.data, doc.documentID)).toList();
  }

  Future removeUser(String id) async {
    _api.removeDocument(id);
  }

  Future updateUser(User data, String id) async {
    _api.updateDocument(data.toJson(), id);
  }

  Future createUser(User data) async {
    return _api.createDocument(data.toJson(), data.id);
  }

  Stream<List<Ping>> streamPings(String id) {
    return getDataFromQuery(
        query: _api.streamSubCollectionById(id, 'pings'),
        mapper: (final DocumentSnapshot messageDoc) =>
            Ping.fromMap(messageDoc.data, messageDoc.documentID));
  }

  Future<DocumentSnapshot> getPingsFrom(String id, String idSender) {
    return _api.getSubCollectionDocumentById(id, 'pings', idSender);
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
