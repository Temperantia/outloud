import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

class Api {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Query queryCollection(
      {List<QueryConstraint> where = const [],
      List<OrderConstraint> orderBy = const []}) {
    return buildQuery(collection: ref, constraints: where, orderBy: orderBy);
  }

  Query querySubCollection(String id, String idCollection,
      {List<QueryConstraint> where = const [],
      List<OrderConstraint> orderBy = const []}) {
    final CollectionReference collection =
        ref.document(id).collection(idCollection);
    return buildQuery(
        collection: collection, constraints: where, orderBy: orderBy);
  }

  Future<DocumentSnapshot> getDocument(String id) {
    return ref.document(id).get();
  }

  Stream<DocumentSnapshot> streamDocument(String id) {
    return ref.document(id).snapshots();
  }

  Future<DocumentSnapshot> getSubCollectionDocument(
      String id, String idCollection, String idDocument) {
    CollectionReference collection = ref.document(id).collection(idCollection);
    return collection.document(idDocument).get();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<DocumentReference> addDocumentToSubCollection(
      Map data, String id, String collection) {
    return ref.document(id).collection(collection).add(data);
  }

  Future<void> createDocument(Map data, String id) {
    return ref.document(id).setData(data);
  }

  Future<void> createDocumentInSubCollection(
      Map data, String id, String collection, String idDocument) {
    return ref
        .document(id)
        .collection(collection)
        .document(idDocument)
        .setData(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<void> removeSubCollectionDocumentById(
      String id, String idCollection, String idDocument) {
    return ref
        .document(id)
        .collection(idCollection)
        .document(idDocument)
        .delete();
  }
}
