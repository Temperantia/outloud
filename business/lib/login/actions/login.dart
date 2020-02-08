// Firebase User login (Email, Phone, Facebook, Google)
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future<void> login(
    AuthCredential credential, String name, DateTime birthdate) async {
  final AuthResult result = await firebaseAuth.signInWithCredential(credential);
  print(result.user.uid);
  print(result.user.displayName);
  print(birthdate);
}
