import 'dart:convert';
import 'package:async_redux/async_redux.dart';
import 'package:business/app.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_listen_action.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
//import 'package:intl/intl.dart';

class LoginFacebookAction extends ReduxAction<AppState> {
  static final FacebookLogin facebookSignIn = FacebookLogin();

  @override
  Future<AppState> reduce() async {
    facebookSignIn.logOut();
    final FacebookLoginResult result =
        await facebookSignIn.logIn(<String>['email']);
    if (result == null) {
      return null;
    }
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final String token = result.accessToken.token;
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: token);

        final Response graphResponse = await get(
            'https://graph.facebook.com/v2.12/me?fields=name,birthday,picture.height(1000)&access_token=$token');
        final Map<String, dynamic> data =
            json.decode(graphResponse.body) as Map<String, dynamic>;
        /* final DateTime birthdate =
            DateFormat.yMd('en_US').parse(data['birthday'] as String);
 */
        final AuthResult authResult =
            await firebaseAuth.signInWithCredential(credential);
        final User user = User(
            //birthDate: birthdate,
            name: authResult.user.displayName,
            id: authResult.user.uid,
            pics: <String>[data['picture']['data']['url'] as String]);

        if (getUser(user.id) != null) {
          dispatch(UserListenAction(user.id));
          dispatch(ChatsListenAction(user.id));
        }
        return state.copy(
            loginState: state.loginState.copy(id: user.id, user: user));
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        return state.copy(
            loginState: state.loginState.copy(
                loginError: 'Something went wrong with the login process.\n'
                    'Here\'s the error Facebook gave us: ${result.errorMessage}'));
    }
    return null;
  }
}
