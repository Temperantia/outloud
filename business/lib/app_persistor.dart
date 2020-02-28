import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/models/chats_state.dart';
import 'package:flutter/material.dart';

// TODO(robin): move login auth mode local persistor here
class AppPersistor extends Persistor<AppState> {
  final LocalPersist chatIdsPersist = LocalPersist('chatIds');

  @override
  Future<AppState> readState() async {
    final List<Object> chatIds = await chatIdsPersist.load() ?? <Object>[];
    return AppState.initialState(
        chatsState: ChatsState.initialState(chatIds: chatIds.cast<String>()));
  }

  @override
  Future<void> deleteState() async {
    // TODO(robin): delete everything saved
  }

  @override
  Future<void> persistDifference(
      {@required AppState lastPersistedState,
      @required AppState newState}) async {
    chatIdsPersist.save(newState.chatsState.chatIds);
  }
}
