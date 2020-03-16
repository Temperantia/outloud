import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';

class ChatsUpdateAction extends ReduxAction<AppState> {
  ChatsUpdateAction(this.messages, this.chatId);

  final List<Message> messages;
  final String chatId;

  @override
  AppState reduce() {
    final List<Chat> chats = state.chatsState.chats;
    final Chat chat = chats.firstWhere((Chat chat) => chat.id == chatId);
    chat.messages = messages;

    chats.sort((Chat chat1, Chat chat2) {
      if (chat1.messages.isEmpty || chat2.messages.isEmpty) {
        return 0;
      }
      return chat1.messages[chat1.messages.length - 1].timestamp >
              chat2.messages[chat2.messages.length - 1].timestamp
          ? -1
          : 1;
    });

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
