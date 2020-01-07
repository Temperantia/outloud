import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/services/api.dart';



class MessageModel extends ChangeNotifier {
  final Api _api = locator<Api>('messages');

  Stream<List<Message>> streamMessages(String conversationId) {
    return getDataFromQuery(
        query: _api.querySubCollection(conversationId, conversationId,
            orderBy: [OrderConstraint('timestamp', true)]),
        mapper: (final DocumentSnapshot messageDoc) =>
            Message.fromMap(messageDoc.data));
  }

  Stream<List<Message>> streamGroupPings(
      Conversation conversation, String idFrom) {
    return getDataFromQuery(
        query: _api.querySubCollection(conversation.id, conversation.id,
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
