import 'package:business/classes/user.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

enum MessageType {
  Text,
  Image,
}

class Message {
  Message(
      {this.idFrom, this.content, this.timestamp, @required this.messageType});

  Message.fromMap(Map<String, dynamic> snapshot)
      : idFrom = snapshot['idFrom'] as String ?? '',
        content = snapshot['content'] as String ?? '',
        timestamp = snapshot['timestamp'] as int ?? 0,
        messageType = snapshot['messageType'] == null
            ? MessageType.Text
            : EnumToString.fromString(
                MessageType.values, snapshot['messageType'] as String);

  final String idFrom;
  final int timestamp;
  final String content;
  final MessageType messageType;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'idFrom': idFrom,
        'timestamp': timestamp,
        'content': content,
        'messageType': EnumToString.parse(messageType)
      };

  String getTimeAgo() =>
      timeago.format(DateTime.fromMillisecondsSinceEpoch(timestamp),
          locale: 'en_short');
}
