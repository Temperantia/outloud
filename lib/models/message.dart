import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/classes/conversation.dart';
import 'package:inclusive/classes/group_ping.dart';
import 'package:inclusive/classes/message.dart';
import 'package:inclusive/classes/message_list.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/api.dart';

class MessageModel extends ChangeNotifier {
  final Api _api = locator<Api>('messages');

  Stream<MessageList> streamMessageList(String conversationId) {
    return getDataFromQuery(
        query: _api.querySubCollection(conversationId, conversationId,
            orderBy: <OrderConstraint>[OrderConstraint('timestamp', true)]),
        mapper: (DocumentSnapshot messageDoc) =>
            Message.fromMap(messageDoc.data)).map<MessageList>(
        (List<Message> messages) => MessageList(messages: messages));
  }

  Stream<Message> streamLastMessage(String conversationId) {
    return getDataFromQuery(
        query: _api.querySubCollection(conversationId, conversationId,
            orderBy: <OrderConstraint>[
              OrderConstraint('timestamp', true)
            ]).limit(1),
        mapper: (DocumentSnapshot messageDoc) =>
            Message.fromMap(messageDoc.data)).map<Message>(
        (List<Message> messages) => messages.isEmpty ? null : messages[0]);
  }

  Stream<GroupPing> streamGroupPings(Conversation conversation, String idFrom) {
    return getDataFromQuery(
        query: _api.querySubCollection(conversation.id, conversation.id,
            where: <QueryConstraint>[
              QueryConstraint(
                  field: 'timestamp', isGreaterThan: conversation.lastRead)
            ]),
        mapper: (DocumentSnapshot messageDoc) =>
            Message.fromMap(messageDoc.data),
        clientSidefilters: <bool Function(Message)>[
          (Message message) => message.idFrom != idFrom
        ]).map<GroupPing>(
        (List<Message> messages) => GroupPing(value: messages.length));
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
