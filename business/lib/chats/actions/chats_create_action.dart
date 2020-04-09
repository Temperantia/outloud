import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';

class ChatsCreateAction extends ReduxAction<AppState> {
  ChatsCreateAction(this._userId);

  final String _userId;

  @override
  AppState reduce() {
    final List<Chat> loungeChats = state.chatsState.loungeChats;
    // final Chat chat = loungeChats.firstWhere((Chat chat) => chat.id == _chatId,
    //     orElse: () => null);

    // if (chat == null) {
    //   return null;
    // }

    // chat.messages = _messages;

    return state.copy(
        chatsState: state.chatsState.copy(loungeChats: loungeChats));
  }
}
