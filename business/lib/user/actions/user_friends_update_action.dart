import 'package:async_redux/async_redux.dart' as redux;
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';

class UserFriendsUpdateAction extends redux.ReduxAction<AppState> {
  UserFriendsUpdateAction(this.friends);

  final List<User> friends;

  @override
  AppState reduce() {
    return state.copy(userState: state.userState.copy(friends: friends));
  }
}
