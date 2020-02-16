import 'dart:convert';
import 'package:http/http.dart';

import 'package:async_redux/async_redux.dart';
import 'package:business/login/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:business/app_state.dart';

class LoginGoogleAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    try {
      final GoogleSignInAccount account = await googleSignIn.signIn();
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
      await register(AuthMode.Google, credential, birthdate);
      return state.copy(loginState: state.loginState.copy(connected: true));
    } catch (error) {
      return state.copy(loginState: state.loginState.copy(connected: false));
    }
  }
}
