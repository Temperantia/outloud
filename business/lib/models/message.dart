import 'package:business/classes/message.dart';
import 'package:business/models/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

final Api _api = Api('messages');

Stream<List<Message>> streamMessages(String conversationId) {
  return getDataFromQuery(
      query: _api.querySubCollection(conversationId, conversationId,
          orderBy: <OrderConstraint>[OrderConstraint('timestamp', true)]),
      mapper: (DocumentSnapshot messageDoc) =>
          Message.fromMap(messageDoc.data));
}

/* Stream<GroupPing> streamGroupPings(Conversation conversation, String idFrom) {
  return getDataFromQuery(
      query: _api.querySubCollection(conversation.id, conversation.id,
          where: <QueryConstraint>[
            QueryConstraint(
                field: 'timestamp', isGreaterThan: conversation.lastRead)
          ]),
      mapper: (DocumentSnapshot messageDoc) => Message.fromMap(messageDoc.data),
      clientSidefilters: <bool Function(Message)>[
        (Message message) => message.idFrom != idFrom
      ]).map<GroupPing>(
      (List<Message> messages) => GroupPing(value: messages.length));
} */

Future<void> addMessage(
    String conversation, String idFrom, String content) async {
  final int timestamp = DateTime.now().millisecondsSinceEpoch;
  _api.addDocumentToSubCollection(
      Message(idFrom: idFrom, content: content, timestamp: timestamp).toJson(),
      conversation,
      conversation);
}
