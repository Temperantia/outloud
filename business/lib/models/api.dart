import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

class Api {
  Api(this.path) {
    ref = _db.collection(path);
  }

  final String path;
  CollectionReference ref;

  final Firestore _db = Firestore.instance;

  Query queryCollection(
      {List<QueryConstraint> where = const <QueryConstraint>[],
      List<OrderConstraint> orderBy = const <OrderConstraint>[],
      dynamic field,
      List<String> whereIn}) {
    return buildQuery(
        collection: field == null || whereIn == null
            ? ref
            : ref.where(field, whereIn: whereIn),
        constraints: where,
        orderBy: orderBy);
  }

  Query querySubCollection(String id, String idCollection,
      {List<QueryConstraint> where = const <QueryConstraint>[],
      List<OrderConstraint> orderBy = const <OrderConstraint>[]}) {
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
    final CollectionReference collection =
        ref.document(id).collection(idCollection);
    return collection.document(idDocument).get();
  }

  Future<DocumentReference> addDocument(Map<String, dynamic> data) {
    return ref.add(data);
  }

  Future<DocumentReference> addDocumentToSubCollection(
      Map<String, dynamic> data, String id, String collection) {
    return ref.document(id).collection(collection).add(data);
  }

  Future<void> createDocument(Map<String, dynamic> data, String id) {
    return ref.document(id).setData(data);
  }

  Future<void> createDocumentInSubCollection(Map<String, dynamic> data,
      String id, String collection, String idDocument) {
    return ref
        .document(id)
        .collection(collection)
        .document(idDocument)
        .setData(data);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
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
