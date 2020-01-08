import 'package:inclusive/classes/user.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/user.dart';

class Message {
  Message({this.idFrom, this.content, this.timestamp});

  Message.fromMap(Map<String, dynamic> snapshot)
      : idFrom = snapshot['idFrom'] as String ?? '',
        content = snapshot['content'] as String ?? '',
        timestamp = snapshot['timestamp'] as int ?? 0;

  final UserModel userProvider = locator<UserModel>();
  final String idFrom;
  final int timestamp;

  User author;
  String content;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'idFrom': idFrom,
      'timestamp': timestamp,
      'content': content,
    };
  }
}