import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class LoungeRemoveAction extends ReduxAction<AppState> {
  LoungeRemoveAction(this.lounge);

  final Lounge lounge;

  @override
  Future<AppState> reduce() async {

    for (final User _user in lounge.members) {
      final List<String> _newLounges = List<String>.from(_user.lounges, growable: true);
      _newLounges.remove(lounge.id);
      updateUserLounge(_user, _newLounges);
      // updateUser(_user);
    }
    
    await deleteLounge(lounge);

    return state;
  }
}