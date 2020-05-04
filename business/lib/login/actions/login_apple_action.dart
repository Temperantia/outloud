import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_listen_action.dart';

import 'package:async_redux/async_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:business/app_state.dart';

class LoginAppleAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    final AuthorizationResult authResult =
        await AppleSignIn.performRequests(<AuthorizationRequest>[
      AppleIdRequest(requestedScopes: <Scope>[Scope.email, Scope.fullName])
    ]);

    switch (authResult.status) {
      case AuthorizationStatus.authorized:
        break;
      case AuthorizationStatus.error:
        dispatch(NavigateAction<AppState>.pop());
        return null;

      case AuthorizationStatus.cancelled:
        dispatch(NavigateAction<AppState>.pop());
        return null;
    }

    final AppleIdCredential appleIdCredential = authResult.credential;

    const OAuthProvider oAuthProvider = OAuthProvider(providerId: 'apple.com');
    final AuthCredential credential = oAuthProvider.getCredential(
      idToken: String.fromCharCodes(appleIdCredential.identityToken),
      accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
    );

    final AuthResult result =
        await FirebaseAuth.instance.signInWithCredential(credential);

    String name;
    if (appleIdCredential.fullName.givenName != null &&
        appleIdCredential.fullName.familyName != null) {
      name = appleIdCredential.fullName.givenName +
          ' ' +
          appleIdCredential.fullName.familyName;
    }

    final String userId = result.user.uid;
    final User user = await getUser(userId) ??
        User(
            name: name,
            id: result.user.uid,
            pics: <String>[result.user.photoUrl]);
    if (user != null) {
      dispatch(UserListenAction(user.id));
    }

    return state.copy(
        loginState: state.loginState.copy(user: user, id: user.id));
  }
}
