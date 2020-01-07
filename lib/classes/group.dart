import 'package:inclusive/classes/entity.dart';

class Group implements Entity {
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