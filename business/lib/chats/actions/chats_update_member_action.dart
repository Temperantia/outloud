import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/user.dart';

class ChatsUpdateMemberAction extends ReduxAction<AppState> {
  ChatsUpdateMemberAction(this._member, this._chatId);

  final User _member;
  final String _chatId;

  @override
  AppState reduce() {
    final List<Chat> chats = state.chatsState.chats;
    final Chat chat =
        chats.firstWhere((Chat chat) => chat.id == _chatId, orElse: () => null);

    if (chat == null) {
      return null;
    }

    chat.entity = _member;

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
