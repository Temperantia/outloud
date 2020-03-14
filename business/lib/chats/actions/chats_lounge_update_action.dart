import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';

class ChatsLoungeUpdateAction extends ReduxAction<AppState> {
  ChatsLoungeUpdateAction(this.messages, this.chatId);

  final List<Message> messages;
  final String chatId;

  @override
  AppState reduce() {
    final List<Chat> loungeChats = state.chatsState.loungeChats;
    final Chat chat = loungeChats.firstWhere((Chat chat) => chat.id == chatId);
    chat.messages = messages;

    return state.copy(
        chatsState: state.chatsState.copy(loungeChats: loungeChats));
  }
}
