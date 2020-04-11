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

    await updateLoungeUser(lounge..memberIds.remove(userId));
    await updateUserLounge(
        state.userState.user, state.userState.user.lounges..remove(lounge.id));
    return null;
  }
}
