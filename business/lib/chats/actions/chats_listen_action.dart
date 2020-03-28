import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_update_action.dart';
import 'package:business/chats/actions/chats_update_member_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/message.dart';
import 'package:business/models/user.dart';

class ChatsListenAction extends ReduxAction<AppState> {
  ChatsListenAction(this._id);

  final String _id;

  static final List<StreamSubscription<List<Message>>> _messagesSubs =
      <StreamSubscription<List<Message>>>[];

  static final List<StreamSubscription<User>> _userSubs =
      <StreamSubscription<User>>[];

  @override
  AppState reduce() {
    _reset();

    final List<Chat> chats = <Chat>[];
    for (final String chatId in state.chatsState.chatIds) {
      final Chat chat = Chat(chatId, _id);
      chats.add(chat);

      _messagesSubs.add(streamMessages(chat.id).listen(
          (List<Message> messages) =>
              dispatch(ChatsUpdateAction(messages, chat.id))));

      _userSubs.add(streamUser(chat.idPeer).listen(
          (User user) => dispatch(ChatsUpdateMemberAction(user, chat.id))));
    }

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }

  void _reset() {
    for (final StreamSubscription<List<Message>> messagesSub in _messagesSubs) {
      messagesSub.cancel();
    }
    _messagesSubs.clear();

    for (final StreamSubscription<User> userSub in _userSubs) {
      userSub.cancel();
    }
    _userSubs.clear();
  }
}
