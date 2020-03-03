// Firebase User login (Email, Phone, Facebook, Google)
import 'package:business/classes/user.dart';
import 'package:business/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FacebookLogin facebookSignIn = FacebookLogin();
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/user.birthday.read',
]);

Future<String> register(
  AuthCredential credential,
  DateTime birthdate,
) async {
  final AuthResult result = await firebaseAuth.signInWithCredential(credential);
  final String id = result.user.uid;
  final String name = result.user.displayName;
  final User user = await getUser(id);
  if (user == null) {
    await createUser(User(id: id, name: name, birthDate: birthdate));
  }

  return id;
}
