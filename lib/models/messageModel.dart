import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/api.dart';

class Message {
  String idFrom;
  String content;
  String timestamp;

  Message({this.idFrom, this.content, this.timestamp});

  Message.fromMap(Map snapshot)
      : idFrom = snapshot['idFrom'] ?? '',
        content = snapshot['content'] ?? '',
        timestamp = snapshot['timestamp'] ?? '';

  toJson() {
    return {
      'idFrom': idFrom,
      'content': content,
      'timestamp': timestamp,
    };
  }
}

class MessageModel extends ChangeNotifier {
  Api _api = locator<Api>('messages');

  Stream<QuerySnapshot> streamMessages(String conversation) {
    return _api.streamSubCollectionById(conversation, conversation,
        orderBy: 'timestamp', descending: true);
  }

  Future<void> addMessage(
      String conversation, String idFrom, String content) async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    _api.addDocumentToSubCollection(
        Message(idFrom: idFrom, content: content, timestamp: timestamp)
            .toJson(),
        conversation, conversation);
  }
}
