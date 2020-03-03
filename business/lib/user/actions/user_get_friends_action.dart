import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

class UserGetFriendsAction extends ReduxAction<AppState> {
  UserGetFriendsAction(this.id);
  final String id;
  @override
  Future<AppState> reduce() async {
    final List<User> friends = await getFriends(id);
    return state.copy(userState: state.userState.copy(friends: friends));
  }
}
