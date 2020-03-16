import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/models/login_state.dart';
import 'package:business/user/models/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDisconnectAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    await FirebaseAuth.instance.signOut();

    return state.copy(
        loginState: LoginState.initialState(),
        userState: UserState.initialState());
  }
}
