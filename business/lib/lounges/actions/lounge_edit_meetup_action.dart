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
  AppState reduce() {
    lounge
      ..date = date
      ..location = location
      ..notes = notes;

    updateLounge(lounge);
    return null;
  }
}
