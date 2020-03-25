import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoungeJoinAction extends ReduxAction<AppState> {
  LoungeJoinAction(this.userId, this.lounge);

  final String userId;
  final Lounge lounge;

  @override
  Future<AppState> reduce() async {
    if (lounge.memberIds.contains(userId)) {
      // TODO(robin): this is good to check, still a lounge is displayed after the user joined it in browsing lounges = bug
      return state;
    }
    final List<String> _userIdes = lounge.memberIds + <String>[userId];
    final List<DocumentReference> _memberRefs =
        lounge.memberRefs + <DocumentReference>[getUserReference(userId)];
    await updateLoungeUser(lounge, _userIdes, _memberRefs);
    
    final List<String> _newLounges =
        List<String>.from(state.userState.user.lounges + <String>[lounge.id]);
    await updateUserLounge(state.userState.user, _newLounges);

    return state;
  }
}
