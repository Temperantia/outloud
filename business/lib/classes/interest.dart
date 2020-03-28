import 'package:flutter/material.dart';

class Interest {
  Interest({@required this.name, this.comment = ''});
  Interest.fromMap(Map<String, String> snapshot)
      : name = snapshot['name'] ?? '',
        comment = snapshot['comment'] ?? '';
  String name;
  String comment;

  Map<String, String> toJson() => <String, String>{
        'name': name,
        'comment': comment,
      };
}
