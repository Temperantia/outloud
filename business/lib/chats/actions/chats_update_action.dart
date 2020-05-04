import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/message_state.dart';

class ChatsUpdateAction extends ReduxAction<AppState> {
  ChatsUpdateAction(this._messages, this._chatId);

  final List<Message> _messages;
  final String _chatId;

  @override
  AppState reduce() {
    final List<Chat> chats = state.chatsState.chats;
    final Chat chat =
        chats.firstWhere((Chat chat) => chat.id == _chatId, orElse: () => null);

    if (chat == null) {
      return null;
    }

    chat.messages = _messages;

    final Map<String, MessageState> messageStates = state.chatsState
        .usersChatsStates[state.userState.user.id][_chatId].messageStates;
    for (final Message message in _messages) {
      if (message.idFrom == state.userState.user.id) {
        messageStates.putIfAbsent(message.id, () => MessageState.Sent);
      } else {
        messageStates.putIfAbsent(
            message.id,
            () => MessageState
                .Received); // TODO(alexandre): insert here push notification
      }
    }

    chats.sort((Chat chat1, Chat chat2) {
      if (chat1.messages.isEmpty) {
        return 1;
      }
      if (chat2.messages.isEmpty) {
        return -1;
      }
      return chat1.messages[0].timestamp > chat2.messages[0].timestamp ? -1 : 1;
    });

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
