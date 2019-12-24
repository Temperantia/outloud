import 'package:flutter/material.dart';
import '../locator.dart';
import '../services/api.dart';

class User {
  String id;
  String device;
  String name;
  String email;
  DateTime birthDate;
  String pics;

User({this.id, this.device, this.name, this.email, this.birthDate, this.pics});

  User.fromMap(Map snapshot, String id) :
        id = id ?? '',
        device = snapshot['device'] ?? '',
        name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        birthDate = snapshot['birthDate'].toDate() ?? '',
        pics = snapshot['pics'] ?? '';

  toJson() {
    return {
      'device': device,
      'name': name,
      'email': email,
      'birth': birthDate,
      'pics': pics,
    };
  }

  int getAge() {
    return DateTime.now().year - birthDate.year;
  }
}


class UserModel extends ChangeNotifier {
  Api _api = locator<Api>();

  Future<User> getUser(String id) async {
    var doc = await _api.getDocumentById(id);
    return doc.data != null ? User.fromMap(doc.data, doc.documentID) : null;
  }

  Future removeUser(String id) async {
    _api.removeDocument(id);
  }

  Future updateUser(User data, String id) async {
    _api.updateDocument(data.toJson(), id);
  }

  Future addUser(User data) async {
    _api.addDocument(data.toJson());
  }
}
