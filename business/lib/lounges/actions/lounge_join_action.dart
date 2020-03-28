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

    final List<String> _userIdes = lounge.memberIds + <String>[userId];
    final List<User> _members = lounge.members + <User>[state.userState.user];

    lounge..memberIds = _userIdes;
    lounge..members = _members;

    state.userState.lounges.add(lounge);

    await updateLoungeUser(lounge, _userIdes);

    final List<String> _newLounges =
        List<String>.from(state.userState.user.lounges + <String>[lounge.id]);

    state.userState.user..lounges = _newLounges;
    await updateUser(state.userState.user);

    return state.copy(
        userState: state.userState.copy(
            user: state.userState.user, lounges: state.userState.lounges));
  }
}
