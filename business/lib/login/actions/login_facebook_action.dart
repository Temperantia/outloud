import 'dart:convert';
import 'package:async_redux/async_redux.dart';
import 'package:business/app_state.dart';
import 'package:business/chats/actions/chats_listen_action.dart';
import 'package:business/login/auth.dart';
import 'package:business/user/actions/user_listen_action.dart';
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

        final String id = await register(credentials, birthdate);
        dispatch(UserListenAction(id));
        dispatch(ChatsListenAction(id));

        return state.copy(loginState: state.loginState.copy(id: id));
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
