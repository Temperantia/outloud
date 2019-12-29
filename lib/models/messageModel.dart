import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/appdata.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/groupModel.dart';
import 'package:inclusive/models/userModel.dart';
import 'package:inclusive/services/api.dart';

class Conversation {
  final String id;
  int lastRead = 0;
  bool isGroup;
  String peerId;

  Conversation(this.id) {
    if (id.contains('-')) {
      isGroup = false;
    } else {
      isGroup = true;
    }
  }

  Future<dynamic> getPeerInfo(final UserModel userProvider,
      final GroupModel groupProvider, final AppData appDataProvider) async {
    if (isGroup) {
      peerId = id;
      return groupProvider.getGroup(peerId);
    }
    peerId = getPeerId(id, appDataProvider);
    return userProvider.getUser(peerId);
  }

  static String getPeerId(
      final String conversationId, final AppData appDataProvider) {
    final List<String> ids = conversationId.split('-');

    return appDataProvider.identifier == ids[0] ? ids[1] : ids[0];
  }
}

class Message {
  String idFrom;
  String content;
  int timestamp;

  Message({this.idFrom, this.content, this.timestamp});

  Message.fromMap(Map snapshot)
      : idFrom = snapshot['idFrom'] ?? '',
        content = snapshot['content'] ?? '',
        timestamp = snapshot['timestamp'] ?? 0;

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

  Stream<List<Message>> streamMessages(String conversationId) {
    return getDataFromQuery(
        query: _api.streamSubCollectionById(conversationId, conversationId,
            orderBy: [OrderConstraint('timestamp', true)]),
        mapper: (final DocumentSnapshot messageDoc) =>
            Message.fromMap(messageDoc.data));
  }

  Stream<List<Message>> streamConversation(
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
