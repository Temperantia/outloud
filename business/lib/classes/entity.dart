import 'package:cloud_firestore/cloud_firestore.dart';

import 'interest.dart';

class Entity {
  Entity({this.id, this.name, this.description, this.location, this.interests});
  final String id;
  String name;
  String description;
  GeoPoint location;
  List<Interest> interests;
}
