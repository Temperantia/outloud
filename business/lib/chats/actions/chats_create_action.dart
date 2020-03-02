import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_update_stream_action.dart';
import 'package:business/chats/actions/chats_update_user_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/message.dart';
import 'package:business/models/user.dart';

class ChatsCreateAction extends ReduxAction<AppState> {
  ChatsCreateAction(this.id);
  final String id;
  @override
  AppState reduce() {
    final List<Chat> chats = state.chatsState.chats;

    final Chat chat = Chat(id, state.loginState.id);
    chats.add(chat);
    streamMessages(chat.id).listen((List<Message> messages) =>
        dispatch(ChatsUpdateStreamAction(messages, chat.id)));
    streamUser(chat.idPeer)
        .listen((User user) => dispatch(ChatsUpdateUserAction(user, chat.id)));

    //chats.sort((Chat chat1, Chat chat2) => chat1.me

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
