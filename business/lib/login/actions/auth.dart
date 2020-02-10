// Firebase User login (Email, Phone, Facebook, Google)
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';
import 'package:business/user/actions/user_update_stream_action.dart';
import 'package:business/user/models/user_state.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FacebookLogin facebookSignIn = FacebookLogin();
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/user.birthday.read',
]);

enum AuthMode {
  Facebook,
  Google,
}

Future<void> register(AuthMode mode, AuthCredential credential,
    DateTime birthdate, Function dispatch) async {
  final AuthResult result = await firebaseAuth.signInWithCredential(credential);
  final String id = result.user.uid;
  final String name = result.user.displayName;
  final User user = await getUser(id);
  if (user == null) {
    await createUser(User(id: id, name: name, birthDate: birthdate));
  }

  listenUser(id, dispatch);

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await sharedPreferences.setString('authMode', EnumToString.parse(mode));
}

Future<bool> login(Function dispatch) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final AuthMode authMode = EnumToString.fromString(
      AuthMode.values, sharedPreferences.getString('authMode'));

  if (authMode == null) {
    return false;
  }

  AuthCredential credentials;
  if (authMode == AuthMode.Facebook) {
    final FacebookAccessToken fbToken = await facebookSignIn.currentAccessToken;
    credentials =
        FacebookAuthProvider.getCredential(accessToken: fbToken.token);
  } else {
    final GoogleSignInAccount account = await googleSignIn.signInSilently();
    final GoogleSignInAuthentication auth = await account.authentication;
    credentials = GoogleAuthProvider.getCredential(
        accessToken: auth.accessToken, idToken: auth.idToken);
  }
  final AuthResult result =
      await firebaseAuth.signInWithCredential(credentials);

  final User user = await getUser(result.user.uid);
  if (user == null) {
    return false;
  }
  listenUser(result.user.uid, dispatch);
  return true;
}

void listenUser(String id, Function dispatch) {
  UserState.userStream = streamUser(id);
  UserState.userStream
      .listen((User user) => dispatch(UserUpdateStreamAction(user)));
}
