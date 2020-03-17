import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/models/lounges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoungeEditMeetupAction extends ReduxAction<AppState> {
  LoungeEditMeetupAction(this.lounge, this.date, this.location, this.notes);

  final Lounge lounge;
  final DateTime date;
  final GeoPoint location;
  final String notes;

  @override
  Future<AppState> reduce() async {
    lounge
      ..date = date
      ..location = location
      ..notes = notes;

    await updateLounge(lounge);
    return state;
  }
}