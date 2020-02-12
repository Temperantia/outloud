import 'dart:convert';
import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/login/actions/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';

class LoginFacebookAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final FacebookLoginResult result =
        await facebookSignIn.logIn(<String>['user_birthday']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final String token = result.accessToken.token;
        final AuthCredential credentials =
            FacebookAuthProvider.getCredential(accessToken: token);

        final Response graphResponse = await get(
            'https://graph.facebook.com/v2.12/me?fields=name,birthday&access_token=$token');
        final Map<String, dynamic> data =
            json.decode(graphResponse.body) as Map<String, dynamic>;
        final DateTime birthdate =
            DateFormat.yMd('en_US').parse(data['birthday'] as String);

        await register(AuthMode.Facebook, credentials, birthdate);

        break;
      case FacebookLoginStatus.cancelledByUser:
        return state.copy();
      case FacebookLoginStatus.error:
        return state.copy(
            loginState: state.loginState.copy(
                loginError: 'Something went wrong with the login process.\n'
                    'Here\'s the error Facebook gave us: ${result.errorMessage}'));
    }
    return state.copy(loginState: state.loginState.copy(connected: true));
  }
}