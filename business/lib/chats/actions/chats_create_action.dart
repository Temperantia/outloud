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
    final String myId = state.userState.user.id;
    final String chatId = Chat.getUserChatId(myId, _userId);

    final Chat chatFound =
        chats.firstWhere((Chat chat) => chat.id == chatId, orElse: () => null);
    if (chatFound != null) {
      dispatch(
          NavigateAction<AppState>.pushNamed('Chat', arguments: chatFound));
      return null;
    }

    final Chat chat = Chat(_userId, myId);

    chats.add(chat);

    updateUser(
        user..chatIds = List<String>.from(user.chatIds + <String>[chat.id]));

    ChatsListenAction.messagesSubs.add(streamMessages(chat.id).listen(
        (List<Message> messages) =>
            dispatch(ChatsUpdateAction(messages, chat.id))));

    ChatsListenAction.userSubs.add(streamUser(chat.idPeer).listen(
        (User user) => dispatch(ChatsUpdateMemberAction(user, chat.id))));

    final Map<String, Map<String, ChatState>> userChatsStates =
        state.chatsState.usersChatsStates;

    userChatsStates[myId][chatId] = ChatState();

    dispatch(NavigateAction<AppState>.pushNamed('Chat', arguments: chat));

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}