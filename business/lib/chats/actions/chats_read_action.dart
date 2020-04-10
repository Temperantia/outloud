import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/message_state.dart';

class ChatsReadAction extends ReduxAction<AppState> {
  ChatsReadAction(this._chatId);

  final String _chatId;

  @override
  AppState reduce() {
    final String userId = state.userState.user.id;
    final Map<String, Map<String, ChatState>> usersChatsStates =
        state.chatsState.usersChatsStates;
    for (final MapEntry<String, MessageState> messageState
        in usersChatsStates[userId][_chatId].messageStates.entries) {
      if (messageState.value == MessageState.Received) {
        usersChatsStates[userId][_chatId].messageStates[messageState.key] =
            MessageState.Read;
      }
    }

    return state.copy(
        chatsState: state.chatsState.copy(usersChatsStates: usersChatsStates));
  }
}
