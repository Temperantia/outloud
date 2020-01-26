import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/classes/group.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/api.dart';

class GroupModel extends ChangeNotifier {
  final Api _api = locator<Api>('groups');

  Stream<Group> streamGroup(String id) {
    return _api
        .streamDocument(id)
        .map((DocumentSnapshot doc) => Group.fromMap(doc.data, doc.documentID));
  }
}