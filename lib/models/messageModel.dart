import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/services/api.dart';
import 'package:inclusive/services/message.dart';

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

  getAuthor() async {
    final User user = await userProvider.getUser(idFrom);
    author = user;
  }
}

class MessageModel extends ChangeNotifier {
  final Api _api = locator<Api>('messages');

  Stream<List<Message>> streamMessages(String conversationId) {
    return  getDataFromQuery(
        query: _api.streamSubCollectionById(conversationId, conversationId,
            orderBy: [OrderConstraint('timestamp', false)]),
        mapper: (final DocumentSnapshot messageDoc) =>
            Message.fromMap(messageDoc.data)); 
         //_api.osef(conversationId).map((messages) => messages.documents.map((mess) => Message.fromMap(mess.data)).toList());
  }

  Stream<List<Message>> streamGroupPings(
      Conversation conversation, String idFrom) {
    return getDataFromQuery(
        query: _api.streamSubCollectionById(conversation.id, conversation.id,
            where: [
              QueryConstraint(
                  field: 'timestamp', isGreaterThan: conversation.lastRead)
            ]),
        mapper: (final DocumentSnapshot messageDoc) =>
            Message.fromMap(messageDoc.data),
        clientSidefilters: [(message) => message.idFrom != idFrom]);
  }

  Future<void> addMessage(
      String conversation, String idFrom, String content) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    _api.addDocumentToSubCollection(
        Message(idFrom: idFrom, content: content, timestamp: timestamp)
            .toJson(),
        conversation,
        conversation);
  }
}
