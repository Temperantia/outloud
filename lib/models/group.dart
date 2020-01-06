import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/api.dart';

class Group {
  Group({this.id, this.name});

  Group.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '';

  final String id;
  final String name;

  toJson() {
    return {
      'name': name,
    };
  }
}

class GroupModel extends ChangeNotifier {
  final Api _api = locator<Api>('groups');

  Stream<Group> streamGroup(String id) {
    return _api.streamDocumentById(id).map((doc) => Group.fromMap(doc.data, doc.documentID));
  }
}
