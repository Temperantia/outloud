import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/api.dart';

class Group {
  String id;
  final String name;
  final List<String> chatMembers;

  Group({this.name, this.chatMembers = const []});

  Group.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        chatMembers = snapshot['chatMembers'].cast<String>() ?? [];

  toJson() {
    return {
      'name': name,
      'chatMembers': chatMembers,
    };
  }
}

class GroupModel extends ChangeNotifier {
  final Api _api = locator<Api>('groups');

  Future<Group> getGroup(String id) async {
    final DocumentSnapshot doc = await _api.getDocumentById(id);
    return doc.data == null ? null : Group.fromMap(doc.data, doc.documentID);
  }
}
