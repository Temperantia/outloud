import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class LoungeJoinAction extends ReduxAction<AppState> {
  LoungeJoinAction(this.userId, this.lounge);

  final String userId;
  final Lounge lounge;

  @override
  Future<AppState> reduce() async {
    if (lounge.memberIds.contains(userId)) {
      // TODO(robin): this is good to check, still a lounge is displayed after the user joined it in browsing lounges = bug
      return null;
    }

    await updateLoungeUser(
        lounge..memberIds.add(userId)..members.add(state.userState.user));

    state.userState..lounges.add(lounge);
    await updateUser(state.userState.user..lounges.add(lounge.id));

    return state.copy(
        userState: state.userState.copy(
            user: state.userState.user, lounges: state.userState.lounges));
  }
}
