import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/message_state.dart';

class ChatsLoungeReadAction extends ReduxAction<AppState> {
  ChatsLoungeReadAction(this._loungeId);

  final String _loungeId;

  @override
  AppState reduce() {
    final String userId = state.userState.user.id;
    final Map<String, Map<String, ChatState>> loungesChatsStates =
        state.chatsState.loungesChatsStates;
    for (final MapEntry<String, MessageState> messageState
        in loungesChatsStates[userId][_loungeId].messageStates.entries) {
      if (messageState.value == MessageState.Received) {
        loungesChatsStates[userId][_loungeId].messageStates[messageState.key] =
            MessageState.Read;
      }
    }

    return state.copy(
        chatsState: state.chatsState.copy(loungesChatsStates: loungesChatsStates));
  }
}
