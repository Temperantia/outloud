import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchService extends ChangeNotifier {
  Future<ConversationList> getConversationList() async {
    final List<Conversation> conversations = <Conversation>[];

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final List<String> conversationIDs =
        sharedPreferences.getStringList('conversationIDs');
    final List<String> conversationLastReads =
        sharedPreferences.getStringList('conversationLastReads');
    if (conversationIDs == null || conversationLastReads == null) {
      return ConversationList(conversations: conversations);
    }
    conversationIDs.asMap().forEach((final int index, final String id) =>
        conversations
            .add(Conversation(id, int.parse(conversationLastReads[index]))));
    return ConversationList(conversations: conversations);
  }
}
