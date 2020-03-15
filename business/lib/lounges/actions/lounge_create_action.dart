import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/models/events.dart';
import 'package:business/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoungeCreateAction extends ReduxAction<AppState> {
  LoungeCreateAction(this.eventId);

  final String eventId;

  @override
  AppState reduce() {
    final String userId = state.loginState.id;

    final Lounge loungeCreation = Lounge(
        memberIds: <String>[userId],
        memberRefs: <DocumentReference>[getUserReference(userId)],
        owner: userId,
        eventId: eventId,
        eventRef: getEventReference(eventId));
    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: loungeCreation));
  }
}
