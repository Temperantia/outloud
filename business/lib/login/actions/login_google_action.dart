import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:business/login/actions/login.dart';
import 'package:business/login/models/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:business/app_state.dart';

class LoginGoogleAction extends ReduxAction<AppState> {
  LoginGoogleAction();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
  ]);

  @override
  Future<AppState> reduce() async {
    print('ok');
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication auth = await account.authentication;
      final Response response = await get(
        'https://people.googleapis.com/v1/people/me'
        '?personFields=birthdays,names',
        headers: await account.authHeaders,
      );
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> birthday =
          data['birthdays'][0]['date'] as Map<String, dynamic>;
      final DateTime birthdate = DateTime(birthday['year'] as int,
          birthday['month'] as int, birthday['day'] as int);
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      login(credential, data['names'][0]['displayName'] as String, birthdate);
      return state.copy(loginState: state.loginState.copy(connected: true));
    } catch (error) {
      print(error);
    }
    return state.copy(loginState: state.loginState.copy(connected: true));
  }
}
