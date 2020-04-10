import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

class UserSendFriendRequest extends ReduxAction<AppState> {
  UserSendFriendRequest(this.userFrom, this.userTo);

  final String userFrom;
  final String userTo;

  @override
  Future<AppState> reduce() async {
    final User _userFrom = await getUser(userFrom);
    final User _userTo = await getUser(userTo);

    final List<String> _newPendingFriendsListTo =
        List<String>.from(_userTo.pendingFriends + <String>[_userFrom.id]);
    final List<String> _newRequestedFriendsListFrom =
        List<String>.from(_userFrom.requestedFriends + <String>[_userTo.id]);

    _userFrom..requestedFriends = _newRequestedFriendsListFrom;
    _userTo..pendingFriends = _newPendingFriendsListTo;

    await updateUser(_userTo);
    await updateUser(_userFrom);

    return state;
  }
}