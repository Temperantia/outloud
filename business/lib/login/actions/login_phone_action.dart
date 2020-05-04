import 'package:async_redux/async_redux.dart';
import 'package:business/app.dart';
import 'package:business/app_state.dart';
import 'package:business/classes/user.dart';
import 'package:business/login/actions/login_error_action.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_listen_action.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPhoneAction extends ReduxAction<AppState> {
  LoginPhoneAction(this._phone);

  final String _phone;

  @override
  Future<AppState> reduce() async {
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) =>
            _verificationComplete(authCredential),
        verificationFailed: (AuthException authException) =>
            _verificationFailed(authException),
        codeSent: (String verificationId, [int code]) =>
            _smsCodeSent(verificationId, <int>[code]),
        codeAutoRetrievalTimeout: (String verificationId) {});
    return state.copy(loginState: state.loginState.copy());
  }

  Future<void> _verificationComplete(AuthCredential authCredential) async {
    final AuthResult result =
        await firebaseAuth.signInWithCredential(authCredential);
    final String userId = result.user.uid;
    final User user = await getUser(userId) ?? User(id: result.user.uid);
    if (user != null) {
      dispatch(UserListenAction(user.id));
    }

    return state.copy(
        loginState: state.loginState.copy(user: user, id: user.id));
  }

  void _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
  }

  void _verificationFailed(AuthException authException) {
    dispatch(LoginErrorAction(authException.message));
  }
}
