import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_update_action.dart';

class UserListenAction extends ReduxAction<AppState> {
  UserListenAction(this.id);

  final String id;

  static StreamSubscription<User> userSub;

  @override
  AppState reduce() {
    if (userSub != null) {
      userSub.cancel();
    }
    userSub = streamUser(id).listen((User user) {
      dispatch(UserUpdateAction(user));
    });
    return null;
  }
}
