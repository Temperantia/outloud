import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/message_state.dart';

class ChatsLoungeUpdateAction extends ReduxAction<AppState> {
  ChatsLoungeUpdateAction(this._messages, this._chatId);

  final List<Message> _messages;
  final String _chatId;

  @override
  AppState reduce() {
    final List<Chat> loungeChats = state.chatsState.loungeChats;
    final Chat chat = loungeChats.firstWhere((Chat chat) => chat.id == _chatId,
        orElse: () => null);

    if (chat == null) {
      return null;
    }

    chat.messages = _messages;

    final Map<String, MessageState> messageStates = state.chatsState
        .loungesChatsStates[state.userState.user.id][_chatId].messageStates;
    for (final Message message in _messages) {
      if (message.idFrom == state.userState.user.id) {
        messageStates.putIfAbsent(message.id, () => MessageState.Sent);
      } else {
        messageStates.putIfAbsent(message.id, () => MessageState.Received);
      }
    }

    return state.copy(
        chatsState: state.chatsState.copy(loungeChats: loungeChats));
  }
}
