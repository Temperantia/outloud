import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

class UserAcceptFriendRequestAction extends ReduxAction<AppState> {
  UserAcceptFriendRequestAction(this.userFrom, this.userTo);

  final String userFrom;
  final String userTo;

  @override
  Future<AppState> reduce() async {
    final User _userFrom = await getUser(userFrom);
    final User _userTo = await getUser(userTo);

    _userTo..pendingFriends.remove(userFrom);
    _userTo..friends.add(userFrom);

    if (_userTo.requestedFriends.contains(_userFrom)) {
      _userTo..requestedFriends.remove(userFrom);
    }

    await updateUser(_userTo);

    _userFrom..requestedFriends.remove(userTo);
    _userFrom..friends.add(userTo);

    if (_userFrom.pendingFriends.contains(_userTo)) {
      _userFrom..requestedFriends.remove(userFrom);
    }

    await updateUser(_userFrom);

    return state;
  }
}
