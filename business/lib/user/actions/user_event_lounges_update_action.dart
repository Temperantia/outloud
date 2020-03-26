import 'dart:async';

import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/event.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/message.dart';
import 'package:business/classes/user.dart';
import 'package:business/user/actions/user_lounge_event_update_action.dart';
import 'package:business/user/actions/user_lounge_member_update_action.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEventLoungesUpdateAction extends redux.ReduxAction<AppState> {
  UserEventLoungesUpdateAction(this.lounges);

  final List<Lounge> lounges;

  static final List<StreamSubscription<Event>> _eventSubs =
      <StreamSubscription<Event>>[];
  static final List<List<StreamSubscription<User>>> _membersSubs =
      <List<StreamSubscription<User>>>[];

  @override
  AppState reduce() {
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

    // TODO(robin): do not add a lounge to the event lounges if there is no room left for new people
    final Map<String, List<Lounge>> eventLounges = <String, List<Lounge>>{};
    for (final Lounge lounge in lounges) {
      final List<Lounge> eventLounge = eventLounges[lounge.eventId];
      if (eventLounge == null) {
        eventLounges[lounge.eventId] = <Lounge>[lounge];
      } else {
        eventLounges[lounge.eventId].add(lounge);
      }

      _streamEvent(lounge);
      _streamMembers(lounge);
    }
    return state.copy(
        userState: state.userState.copy(eventLounges: eventLounges));
  }

  void _streamEvent(Lounge lounge) {
    _eventSubs.add(lounge.eventRef
        .snapshots()
        .map((DocumentSnapshot doc) => Event.fromMap(doc.data, doc.documentID))
        .listen((Event event) =>
            dispatch(UserLoungeEventUpdateAction(event, lounge.id))));
  }

  void _streamMembers(Lounge lounge) {
    final List<StreamSubscription<User>> memberSubs =
        <StreamSubscription<User>>[];
    for (final DocumentReference memberRef in lounge.memberRefs) {
      memberSubs.add(memberRef
          .snapshots()
          .map((DocumentSnapshot doc) => User.fromMap(doc.data, doc.documentID))
          .listen((User user) =>
              dispatch(UserLoungeMemberUpdateAction(user, lounge.id))));
    }
    _membersSubs.add(memberSubs);
  }
}
