import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoungeCreateMeetupAction extends ReduxAction<AppState> {
  LoungeCreateMeetupAction(this._location, this._date, this._notes);

  final GeoPoint _location;
  final DateTime _date;
  final String _notes;

  @override
  Future<AppState> reduce() async {
    Lounge loungeCreation = state.loungesState.loungeCreation
      ..location = _location
      ..date = _date
      ..notes = _notes;

    loungeCreation = await createLounge(loungeCreation);

    final User user = state.userState.user;

    user.lounges =
        List<String>.from(user.lounges + <String>[loungeCreation.id]);

    updateUser(user);

    dispatch(NavigateAction<AppState>.pushNamedAndRemoveUntil(
        'LoungeChatScreen',
        arguments: loungeCreation,
        predicate: (Route<dynamic> route) => route.isFirst));

    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: loungeCreation));
  }
}
