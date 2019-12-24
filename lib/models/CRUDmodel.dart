import 'package:flutter/material.dart';
import '../locator.dart';
import '../services/api.dart';
import '../models/userModel.dart';

class CRUDModel extends ChangeNotifier {
  Api _api = locator<Api>();

  User user;

  Future<User> getUser(String id) async {
    var doc = await _api.getDocumentById(id);
    return User.fromMap(doc.data, doc.documentID);
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
