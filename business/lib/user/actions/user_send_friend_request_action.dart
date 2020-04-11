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

    _userFrom..requestedFriends.add(_userTo.id);
    _userTo..pendingFriends.add(_userFrom.id);

    await updateUser(_userTo);
    await updateUser(_userFrom);

    return state;
  }
}
