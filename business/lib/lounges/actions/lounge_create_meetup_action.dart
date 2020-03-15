import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoungeCreateMeetupAction extends ReduxAction<AppState> {
  LoungeCreateMeetupAction(this.location, this.date, this.notes);

  final GeoPoint location;
  final DateTime date;
  final String notes;

  @override
  Future<AppState> reduce() async {
    Lounge lounCreation = state.loungesState.loungeCreation
      ..location = location
      ..date = date
      ..notes = notes;

    lounCreation = await createLounge(lounCreation);

    final User user = state.userState.user;

    user.lounges = List<String>.from(user.lounges + <String>[lounCreation.id]);

    updateUser(user);

    return state.copy(
        loungesState: state.loungesState.copy(loungeCreation: lounCreation));
  }
}
