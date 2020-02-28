import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/user.dart';

class ChatsUpdateUserAction extends ReduxAction<AppState> {
  ChatsUpdateUserAction(this.user, this.chatId);

  final User user;
  final String chatId;

  @override
  AppState reduce() {
    final List<Chat> chats = state.chatsState.chats;
    final Chat chat = chats.firstWhere((Chat chat) => chat.id == chatId);
    chat.entity = user;

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
