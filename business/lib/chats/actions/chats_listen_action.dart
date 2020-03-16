import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_update_action.dart';
import 'package:business/chats/actions/chats_update_user_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/message.dart';
import 'package:business/models/user.dart';

class ChatsListenAction extends ReduxAction<AppState> {
  ChatsListenAction(this.id);

  final String id;

  static List<StreamSubscription<List<Message>>> messagesSubs =
      <StreamSubscription<List<Message>>>[];

  static List<StreamSubscription<User>> userSubs = <StreamSubscription<User>>[];

  @override
  AppState reduce() {
    for (final StreamSubscription<List<Message>> messagesSub in messagesSubs) {
      messagesSub.cancel();
    }
    messagesSubs.clear();

    for (final StreamSubscription<User> userSub in userSubs) {
      userSub.cancel();
    }
    userSubs.clear();

    final List<Chat> chats = <Chat>[];
    for (final String chatId in state.chatsState.chatIds) {
      final Chat chat = Chat(chatId, id);
      chats.add(chat);

      messagesSubs.add(streamMessages(chat.id).listen(
          (List<Message> messages) =>
              dispatch(ChatsUpdateAction(messages, chat.id))));

      userSubs.add(streamUser(chat.idPeer).listen(
          (User user) => dispatch(ChatsUpdateUserAction(user, chat.id))));
    }

    return state.copy(chatsState: state.chatsState.copy(chats: chats));
  }
}
