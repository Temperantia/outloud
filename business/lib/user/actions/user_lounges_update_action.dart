import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_lounge_update_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/message.dart';
import 'package:business/models/message.dart';

class UserLoungesUpdateAction extends ReduxAction<AppState> {
  UserLoungesUpdateAction(this.lounges);

  final List<Lounge> lounges;

  static List<StreamSubscription<List<Message>>> messagesSub =
      <StreamSubscription<List<Message>>>[];

  @override
  AppState reduce() {
    for (final StreamSubscription<List<Message>> messageSub in messagesSub) {
      messageSub.cancel();
    }
    messagesSub.clear();

    final List<Chat> chats = <Chat>[];
    for (final Lounge lounge in lounges) {
      final Chat chat = Chat(lounge.id, state.loginState.id);
      chats.add(chat);
      messagesSub.add(streamMessages(chat.id).listen((List<Message> messages) =>
          dispatch(ChatsLoungeUpdateAction(messages, chat.id))));
    }
    return state.copy(
        chatsState: state.chatsState.copy(loungeChats: chats),
        userState: state.userState.copy(lounges: lounges));
  }
}
