import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:business/chats/actions/chats_update_action.dart';
import 'package:business/chats/actions/chats_update_member_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/message.dart';
import 'package:business/models/user.dart';

class ChatsCreateAction extends ReduxAction<AppState> {
  ChatsCreateAction(this._userId);

  final String _userId;

  @override
  AppState reduce() {
    final List<Chat> chats = state.chatsState.chats;
    final User user = state.userState.user;
    final String myId = user.id;
    final Chat chat = Chat.user(myId, _userId);

    final Chat chatFound =
        chats.firstWhere((Chat c) => c.id == chat.id, orElse: () => null);
    if (chatFound != null) {
      dispatch(
          NavigateAction<AppState>.pushNamed('Chat', arguments: chatFound));
      return null;
    }

    chats.add(chat);

    updateUser(
        user..chatIds = List<String>.from(user.chatIds + <String>[chat.id]));

    ChatsListenAction.messagesSubs.add(streamMessages(chat.id).listen(
        (List<Message> messages) =>
            dispatch(ChatsUpdateAction(messages, chat.id))));

    ChatsListenAction.userSubs.add(streamUser(chat.idPeer).listen(
        (User user) => dispatch(ChatsUpdateMemberAction(user, chat.id))));

    final Map<String, Map<String, ChatState>> usersChatsStates =
        state.chatsState.usersChatsStates;

    usersChatsStates[myId].putIfAbsent(chat.id, () => ChatState());

    dispatch(NavigateAction<AppState>.pushNamed('Chat', arguments: chat));

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
