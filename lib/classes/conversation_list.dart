import 'package:inclusive/classes/conversation.dart';

class ConversationList {
  ConversationList({this.conversations}) {
    for (final Conversation conversation in conversations) {
      conversation.messageList = conversation.streamMessageList();
      conversation.peerData = conversation.streamPeerInfo();
      if (conversation.isGroup) {
        conversation.groupPings = conversation.streamGroupPings();
      }
    }
  }
  List<Conversation> conversations = <Conversation>[];
}
