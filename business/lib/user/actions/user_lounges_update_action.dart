import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_lounge_update_action.dart';
import 'package:business/classes/chat.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/events.dart';
import 'package:business/models/message.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_lounge_event_update_action.dart';
import 'package:business/user/actions/user_lounge_member_update_action.dart';

class UserLoungesUpdateAction extends redux.ReduxAction<AppState> {
  UserLoungesUpdateAction(this._lounges);

  final List<Lounge> _lounges;

  static final List<StreamSubscription<List<Message>>> _messagesSub =
      <StreamSubscription<List<Message>>>[];
  static final List<StreamSubscription<Event>> _eventSubs =
      <StreamSubscription<Event>>[];
  static final List<List<StreamSubscription<User>>> _membersSubs =
      <List<StreamSubscription<User>>>[];

  @override
  AppState reduce() {
    _reset();

    final List<Chat> chats = <Chat>[];
    for (final Lounge lounge in _lounges) {
      final Chat chat = Chat(lounge.id, state.loginState.id);
      chats.add(chat);
      _messagesSub.add(streamMessages(chat.id).listen(
          (List<Message> messages) =>
              dispatch(ChatsLoungeUpdateAction(messages, chat.id))));
      _streamEvent(lounge);
      _streamMembers(lounge);
    }
    return state.copy(
        chatsState: state.chatsState.copy(loungeChats: chats),
        userState: state.userState.copy(lounges: _lounges));
  }

  void _reset() {
    for (final StreamSubscription<List<Message>> messageSub in _messagesSub) {
      messageSub.cancel();
    }
    _messagesSub.clear();
    for (final StreamSubscription<Event> eventSub in _eventSubs) {
      eventSub.cancel();
    }
    _eventSubs.clear();
    for (final List<StreamSubscription<User>> memberSubList in _membersSubs) {
      for (final StreamSubscription<User> memberSub in memberSubList) {
        memberSub.cancel();
      }
      memberSubList.clear();
    }
    _membersSubs.clear();
  }

  void _streamEvent(Lounge lounge) {
    _eventSubs.add(streamEvent(lounge.eventId).listen((Event event) =>
        dispatch(UserLoungeEventUpdateAction(event, lounge.id))));
  }

  void _streamMembers(Lounge lounge) {
    final List<StreamSubscription<User>> memberSubs =
        <StreamSubscription<User>>[];
    for (final String memberId in lounge.memberIds) {
      memberSubs.add(streamUser(memberId).listen((User user) =>
          dispatch(UserLoungeMemberUpdateAction(user, lounge.id))));
    }
    _membersSubs.add(memberSubs);
  }
}
