import 'package:inclusive/classes/conversation.dart';

class ConversationList {
  ConversationList({this.conversations = const <Conversation>[]});
  final List<Conversation> conversations;

  bool hasUserConversation(String idPeer) {
    print(idPeer);
    return conversations
        .any((Conversation conversation) => conversation.idPeer == idPeer);
  }
}
