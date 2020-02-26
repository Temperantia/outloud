import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';

class ChatsListenAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    final List<Chat> chats = <Chat>[];
    for (final String chatId in state.chatsState.chatIds) {
      chats.add(Chat(chatId, state.loginState.id));
    }

    //chats.sort((Chat chat1, Chat chat2) => chat1.me

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}