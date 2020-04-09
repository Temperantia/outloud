import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_update_action.dart';
import 'package:business/chats/actions/chats_update_member_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/chat_state.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/message.dart';
import 'package:business/models/user.dart';

class ChatsListenAction extends ReduxAction<AppState> {
  ChatsListenAction(this._id, this._chatIds);

  final String _id;
  final List<String> _chatIds;

  static final List<StreamSubscription<List<Message>>> messagesSubs =
      <StreamSubscription<List<Message>>>[];

  static final List<StreamSubscription<User>> userSubs =
      <StreamSubscription<User>>[];

  @override
  AppState reduce() {
    _reset();

    final List<Chat> chats = <Chat>[];
    final Map<String, Map<String, ChatState>> usersChatStates =
        state.chatsState.usersChatsStates;
    for (final String chatId in _chatIds) {
      final Chat chat = Chat(chatId, _id);
      chats.add(chat);

      messagesSubs.add(streamMessages(chat.id).listen(
          (List<Message> messages) =>
              dispatch(ChatsUpdateAction(messages, chat.id))));

      userSubs.add(streamUser(chat.idPeer).listen(
          (User user) => dispatch(ChatsUpdateMemberAction(user, chat.id))));

      final Map<String, Map<String, ChatState>> userChatsStates =
          state.chatsState.usersChatsStates;

      userChatsStates[_id][chatId] = ChatState();
    }

    return state.copy(
        chatsState: state.chatsState
            .copy(chats: chats, usersChatsStates: usersChatStates));
  }

  void _reset() {
    for (final StreamSubscription<List<Message>> messagesSub in messagesSubs) {
      messagesSub.cancel();
    }
    messagesSubs.clear();

    for (final StreamSubscription<User> userSub in userSubs) {
      userSub.cancel();
    }
    userSubs.clear();
  }
}
