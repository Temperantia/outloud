import 'dart:convert';
import 'package:business/app.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_listen_action.dart';
import 'package:http/http.dart';

import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:business/app_state.dart';

class LoginGoogleAction extends ReduxAction<AppState> {
  static final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
  ]);

  @override
  Future<AppState> reduce() async {
    try {
      final GoogleSignInAccount account =
          await googleSignIn.signIn().catchError((Object error) => null);
      if (account == null) {
        return null;
      }
      final GoogleSignInAuthentication auth = await account.authentication;
      final Response response = await get(
        'https://people.googleapis.com/v1/people/me'
        '?personFields=birthdays,names',
        headers: await account.authHeaders,
      );
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      Map<String, dynamic> birthday;
      for (final Map<String, dynamic> info in data['birthdays']) {
        if (info['metadata']['source']['type'] == 'ACCOUNT') {
          birthday = info['date'] as Map<String, dynamic>;
        }
      }
      final DateTime birthdate = DateTime(birthday['year'] as int,
          birthday['month'] as int, birthday['day'] as int);
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      final AuthResult result =
          await firebaseAuth.signInWithCredential(credential);

      final User user = User(
          birthDate: birthdate,
          name: result.user.displayName,
          id: result.user.uid,
          pics: <String>[result.user.photoUrl]);

      if (getUser(user.id) != null) {
        dispatch(UserListenAction(user.id));
        dispatch(ChatsListenAction(user.id));
      }

      return state.copy(
          loginState: state.loginState.copy(user: user, id: user.id));
    } catch (error) {
      return state.copy(
          loginState: state.loginState.copy(loginError: error.toString()));
    }
  }
}
