import 'package:inclusive/classes/user.dart';

class Message {
  Message({this.idFrom, this.content, this.timestamp});

  Message.fromMap(Map<String, dynamic> snapshot)
      : idFrom = snapshot['idFrom'] as String ?? '',
        content = snapshot['content'] as String ?? '',
        timestamp = snapshot['timestamp'] as int ?? 0;

  final String idFrom;
  final int timestamp;
  final String content;

  User author;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idFrom': idFrom,
      'timestamp': timestamp,
      'content': content,
    };
  }
}
