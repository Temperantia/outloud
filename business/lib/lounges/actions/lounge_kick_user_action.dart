import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/lounge.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/lounges.dart';
import 'package:business/models/user.dart';

class LoungeKickUserAction extends ReduxAction<AppState> {
  LoungeKickUserAction(this.userId, this.lounge);

  final String userId;
  final Lounge lounge;

  @override
  Future<AppState> reduce() async {
    if (!lounge.memberIds.contains(userId)) {
      // TODO(robin): this is good to check, still a lounge is displayed after the user joined it in browsing lounges = bug
      return null;
    }
    final User _user = await getUser(userId);

    final List<String> _userIdes = List<String>.from(lounge.memberIds);
    _userIdes.remove(userId);

    await updateLoungeUser(lounge, _userIdes);
    final List<String> _goodLounges = List<String>.from(_user.lounges);
    _goodLounges.remove(lounge.id);
    await updateUserLounge(_user, _goodLounges);
    return state;
  }
}
