import 'package:inclusive/classes/entity.dart';

class Group extends Entity {
  Group({this.id, String name}) : super(name);

  Group.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id ?? '',
        super(snapshot['name'] as String);

  final String id;

  List<String> interests;

  String owner;
  List<String> adminIds;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }
}
