import 'package:business/classes/lounge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:business/models/api.dart';

final Api _api = Api('lounges');

Stream<Lounge> streamLounge(String id) {
  return _api
      .streamDocument(id)
      .map((DocumentSnapshot doc) => Lounge.fromMap(doc.data, doc.documentID));
}

Stream<List<Lounge>> streamLounges({List<String> ids}) {
  return _api.queryCollection(whereIn: ids).snapshots().map<List<Lounge>>(
      (QuerySnapshot querySnapshot) => querySnapshot.documents
          .map<Lounge>((DocumentSnapshot doc) =>
              Lounge.fromMap(doc.data, doc.documentID))
          .toList());
}

Future<Lounge> createLounge() async {
  return Lounge(id: (await _api.addDocument({})).documentID);
}

Future<void> updateLounge(Lounge lounge) async {
  return _api.updateDocument(lounge.toJson(), lounge.id);
}