import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;

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

  Future<void> getAuthor() async {
    author = await getUser(idFrom);
  }

  String getTimeAgo() {
    return timeago.format(DateTime.fromMillisecondsSinceEpoch(timestamp), locale: 'en_short');
  }
}
