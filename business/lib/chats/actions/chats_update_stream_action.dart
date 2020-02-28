import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';

class ChatsUpdateStreamAction extends ReduxAction<AppState> {
  ChatsUpdateStreamAction(this.messages, this.chatId);

  final List<Message> messages;
  final String chatId;

  @override
  AppState reduce() {
    final List<Chat> chats = state.chatsState.chats;
    final Chat chat = chats.firstWhere((Chat chat) => chat.id == chatId);
    chat.messages = messages;

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
