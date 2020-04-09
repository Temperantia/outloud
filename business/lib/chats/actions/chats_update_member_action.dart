import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

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

    updateUser(_member
      ..chatIds = List<String>.from(_member.chatIds + <String>[chat.id]));

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
