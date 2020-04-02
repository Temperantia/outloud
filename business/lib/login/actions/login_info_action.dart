import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_listen_action.dart';

class LoginInfoAction extends ReduxAction<AppState> {
  LoginInfoAction(this._user);

  final User _user;

  @override
  Future<AppState> reduce() async {
    await createUser(_user);
    dispatch(UserListenAction(_user.id));
    dispatch(ChatsListenAction(_user.id));

    return state.copy(loginState: state.loginState.copy(user: _user));
  }
}
