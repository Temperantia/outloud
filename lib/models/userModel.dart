import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../locator.dart';
import 'package:inclusive/services/api.dart';

class User {
  String id;
  String name;
  String email;
  String location;
  DateTime birthDate;
  String description;
  List interests;
  String pics;

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
}

class UserModel extends ChangeNotifier {
  Api _api = locator<Api>('users');

  Future<User> getUser(String id) async {
    DocumentSnapshot doc = await _api.getDocumentById(id);
    return doc.data == null ? null : User.fromMap(doc.data, doc.documentID);
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

  Future removeUser(String id) async {
    _api.removeDocument(id);
  }

  Future updateUser(User data, String id) async {
    _api.updateDocument(data.toJson(), id);
  }

  Future createUser(User data, String id) async {
    _api.createDocument(data.toJson(), id);
  }

  Stream<QuerySnapshot> streamPings(String id) {
    return _api.streamSubCollectionById(id, 'pings');
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
    _api.createDocumentInSubCollection(Map<String, dynamic>.from({'value': pings}),
        idNotified, 'pings', idSender);
  }
}
