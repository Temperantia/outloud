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

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idFrom': idFrom,
        'timestamp': timestamp,
        'content': content
      };

  String getTimeAgo() =>
      timeago.format(DateTime.fromMillisecondsSinceEpoch(timestamp),
          locale: 'en_short');
}
