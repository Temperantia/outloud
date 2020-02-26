import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_update_stream_action.dart';
import 'package:business/user/models/user_state.dart';

class UserListenStreamAction extends ReduxAction<AppState> {
  UserListenStreamAction(this.id);
  final String id;
  @override
  AppState reduce() {
    UserState.userStream = streamUser(id);
    UserState.userStream
        .listen((User user) {
          dispatch(UserUpdateStreamAction(user));
        });
    return null;
  }
}
