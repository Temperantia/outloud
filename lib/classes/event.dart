import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inclusive/classes/group.dart';

class Event extends Group {
  List<Map<DateTime, DateTime>> dates;
  GeoPoint location;
  String groupId;
}
