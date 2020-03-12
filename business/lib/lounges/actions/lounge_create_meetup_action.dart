import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoungeCreateMeetupAction extends ReduxAction<AppState> {
  LoungeCreateMeetupAction(this.location, this.date, this.notes, this.id);
  
  final GeoPoint location;
  final DateTime date;
  final String notes;
  final String id;

  @override
  AppState reduce() {
    final Lounge lounCreation = state.loungesState.loungeCreation
      ..location = location
      ..date = date
      ..notes = notes
      ..id = id;
      return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: lounCreation));
  }
}