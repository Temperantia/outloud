import 'package:inclusive/classes/user.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/user.dart';

class Message {
  Message({this.idFrom, this.content, this.timestamp});

  Message.fromMap(Map snapshot)
      : idFrom = snapshot['idFrom'] ?? '',
        content = snapshot['content'] ?? '',
        timestamp = snapshot['timestamp'] ?? 0;

  final UserModel userProvider = locator<UserModel>();
  final String idFrom;
  final int timestamp;

  User author;
  String content;

  toJson() {
    return {
      'idFrom': idFrom,
      'content': content,
      'timestamp': timestamp,
    };
  }
}