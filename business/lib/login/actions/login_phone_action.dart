import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/auth.dart';
import 'package:business/login/actions/login_error_action.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPhoneAction extends ReduxAction<AppState> {
  LoginPhoneAction(this._phone, this._context);

  final String _phone;
  final BuildContext _context;
  static String smsCode;

  @override
  Future<AppState> reduce() async {
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) =>
            _verificationComplete(authCredential, _context),
        verificationFailed: (AuthException authException) =>
            _verificationFailed(authException),
        codeSent: (String verificationId, [int code]) =>
            _smsCodeSent(verificationId, <int>[code]),
        codeAutoRetrievalTimeout: (String verificationId) {});
    return state.copy(loginState: state.loginState.copy());
  }

  Future<void> _verificationComplete(
      AuthCredential authCredential, BuildContext context) async {
    //final AuthResult authResult =
    //   await firebaseAuth.signInWithCredential(authCredential);
    //register()
  }

  void _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    smsCode = verificationId;
  }

  void _verificationFailed(AuthException authException) {
    dispatch(LoginErrorAction(authException.message));
  }
}
