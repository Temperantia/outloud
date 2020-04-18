import 'dart:async';

import 'package:async_redux/async_redux.dart' show ReduxAction;
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_event_users_update_action.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

class ChatsEventUpdateAction extends ReduxAction<AppState> {
  ChatsEventUpdateAction(this._messages, this._chatId);

  final List<Message> _messages;
  final String _chatId;

  static final List<StreamSubscription<List<User>>> memberSubs =
      <StreamSubscription<List<User>>>[];

  @override
  AppState reduce() {
    final List<Event> events = state.eventsState.events;
    final Event event = events.firstWhere((Event event) => event.id == _chatId,
        orElse: () => null);
    if (event == null) {
      return null;
    }
    event.messages = _messages;

    if (_messages.isNotEmpty) {
      final List<String> users = <String>[];

      for (final Message message in _messages) {
        if (!users.contains(message.idFrom)) {
          users.add(message.idFrom);
        }
      }

      memberSubs.add(streamUsers(ids: users).listen((List<User> users) =>
          dispatch(ChatsEventUsersUpdateAction(users, _chatId))));
    }

    return state.copy(eventsState: state.eventsState.copy(events: events));
  }
}
