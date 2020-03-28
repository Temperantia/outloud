import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class LoungeLeaveAction extends ReduxAction<AppState> {
  LoungeLeaveAction(this.userId, this.lounge);

  final String userId;
  final Lounge lounge;

  @override
  Future<AppState> reduce() async {
    if (!lounge.memberIds.contains(userId)) {
      // TODO(robin): this is good to check, still a lounge is displayed after the user joined it in browsing lounges = bug
      return null;
    }
    final int _indexOfUserId = lounge.memberIds.indexOf(userId);

    final List<String> _userIdes = lounge.memberIds.sublist(0, _indexOfUserId) +
        lounge.memberIds.sublist(_indexOfUserId, lounge.memberIds.length - 1);

    await updateLoungeUser(lounge, _userIdes);

    final int _indexLounge = state.userState.user.lounges.indexOf(lounge.id);
    final List<String> _newLounges =
        state.userState.user.lounges.sublist(0, _indexLounge) +
            state.userState.user.lounges
                .sublist(_indexLounge, state.userState.user.lounges.length - 1);
    await updateUserLounge(state.userState.user, _newLounges);
    return null;
  }
}
