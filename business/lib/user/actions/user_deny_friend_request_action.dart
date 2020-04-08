import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

class UserDenyFriendRequestAction extends ReduxAction<AppState> {
  UserDenyFriendRequestAction(this.userFrom, this.userTo);

  final String userFrom;
  final String userTo;

  @override
  Future<AppState> reduce() async {
    final User _userFrom = await getUser(userFrom);
    final User _userTo = await getUser(userTo);

    final List<String> _newPendingFriendsListTo =
        List<String>.from(_userTo.pendingFriends);
    _newPendingFriendsListTo.remove(userFrom);

    _userTo..pendingFriends = _newPendingFriendsListTo;

    if (_userTo.requestedFriends.contains(_userFrom)) {
      final List<String> _newRequestedFriendsListTo =
          List<String>.from(_userTo.requestedFriends);
      _newRequestedFriendsListTo.remove(userFrom);
      _userTo..requestedFriends = _newRequestedFriendsListTo;
    }

    await updateUser(_userTo);

    final List<String> _newRequestedFriendsListFrom =
        List<String>.from(_userFrom.requestedFriends);
    _newRequestedFriendsListFrom.remove(userTo);

    _userFrom..requestedFriends = _newRequestedFriendsListFrom;

    if (_userFrom.pendingFriends.contains(_userTo)) {
      final List<String> _newPendingFriendsListTo =
          List<String>.from(_userFrom.pendingFriends);
      _newPendingFriendsListTo.remove(userFrom);
      _userFrom..requestedFriends = _newPendingFriendsListTo;
    }

    await updateUser(_userFrom);

    return state;
  }
}
