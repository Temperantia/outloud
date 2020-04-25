import 'package:business/classes/message.dart';
import 'package:business/models/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

final Api _api = Api('eventMessages');

Stream<List<Message>> streamEventMessages(String conversationId) {
  return getDataFromQuery(
      query: _api.querySubCollection(conversationId, conversationId,
          orderBy: <OrderConstraint>[OrderConstraint('timestamp', true)]),
      mapper: (DocumentSnapshot messageDoc) =>
          Message.fromMap(messageDoc.data, messageDoc.documentID));
}

void addEventMessage(String conversation, String idFrom, String content,
    MessageType messageType) {
  final int timestamp = DateTime.now().millisecondsSinceEpoch;
  _api.addDocumentToSubCollection(
      Message(
              idFrom: idFrom,
              content: content,
              timestamp: timestamp,
              messageType: messageType)
          .toJson(),
      conversation,
      conversation);
}
