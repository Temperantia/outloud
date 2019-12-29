import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

class Api {
  Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<QuerySnapshot> getSubCollectionById(String id, String idCollection,
      {dynamic orderBy, bool descending}) {
    CollectionReference collection = ref.document(id).collection(idCollection);
    if (orderBy != null) {
      collection = collection.orderBy(orderBy, descending: descending);
    }
    return collection.getDocuments();
  }

  Future<DocumentSnapshot> getSubCollectionDocumentById(
      String id, String idCollection, String idDocument) {
    CollectionReference collection = ref.document(id).collection(idCollection);
    return collection.document(idDocument).get();
  }

  Query streamSubCollectionById(String id, String idCollection,
      {List<QueryConstraint> where = const [],
      List<OrderConstraint> orderBy = const []}) {
    final CollectionReference collection =
        ref.document(id).collection(idCollection);
    return buildQuery(
        collection: collection, constraints: where, orderBy: orderBy);
  }

  Future<QuerySnapshot> getDocumentsByField(dynamic field, dynamic value) {
    return ref.where(field, isEqualTo: value).getDocuments();
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

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<DocumentReference> addDocumentToSubCollection(
      Map data, String id, String collection) {
    return ref.document(id).collection(collection).add(data);
  }

  Future<void> createDocumentInSubCollection(
      Map data, String id, String collection, String idDocument) {
    return ref
        .document(id)
        .collection(collection)
        .document(idDocument)
        .setData(data);
  }

  Future<void> createDocument(Map data, String id) {
    return ref.document(id).setData(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }
}
