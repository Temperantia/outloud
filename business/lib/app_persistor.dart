import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/chats_state.dart';
import 'package:business/classes/chat_state.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

class AppPersistor extends Persistor<AppState> {
  final LocalPersist usersChatsStatesPersist = LocalPersist('usersChatsStates');
  final LocalPersist themePersist = LocalPersist('theme');

  @override
  Future<AppState> readState() async {
    final List<Object> theme = await themePersist.load();
    final Map<String, dynamic> usersChatsStates =
        await usersChatsStatesPersist.loadAsObj();

    return AppState.initialState(
        chatsState: ChatsState.initialState(
            usersChatsStates: usersChatsStates == null
                ? <String, Map<String, ChatState>>{}
                : usersChatsStates.map((String key, dynamic value) =>
                    MapEntry<String, Map<String, ChatState>>(
                        key,
                        (value as Map<String, dynamic>).map<String, ChatState>(
                            (String key, dynamic value) =>
                                MapEntry<String, ChatState>(key,
                                    ChatState.fromJson(value as Map<String, dynamic>)))))),
        theme: theme == null || theme.isEmpty ? null : EnumToString.fromString(ThemeStyle.values, theme[0].toString()));
  }

  @override
  Future<void> deleteState() async {}

  @override
  Future<void> persistDifference(
      {@required AppState lastPersistedState,
      @required AppState newState}) async {
    themePersist.save(<String>[EnumToString.parse(newState.theme)]);
    usersChatsStatesPersist.save(<Map<String, dynamic>>[
      newState.chatsState.usersChatsStates.map((String key,
              Map<String, ChatState> value) =>
          MapEntry<String, Map<String, dynamic>>(
              key,
              value.map<String, dynamic>((String key, ChatState value) =>
                  MapEntry<String, Map<String, dynamic>>(key, value.toJson()))))
    ]);
  }
}
