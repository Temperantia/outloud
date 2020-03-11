import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_create_action.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

StoreTester<AppState> storeTester =
    StoreTester<AppState>(initialState: AppState.initialState());
const String loginId = 'b';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  storeTester.dispatch(ChatsListenAction(loginId));
  final TestInfo<AppState> _ =
      await storeTester.wait(ChatsListenAction) as TestInfo<AppState>;
  group('Chats', () {
    test('it should create a new chat and add it to the list', () async {
      storeTester.dispatch(ChatsCreateAction('b-c'));
      final TestInfo<AppState> info =
          await storeTester.wait(ChatsCreateAction) as TestInfo<AppState>;
      expect(info.state.chatsState.chats[0].id, 'b-c');
    });
  });
}
