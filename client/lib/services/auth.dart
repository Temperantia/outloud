import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:inclusive/classes/user.dart';
import 'package:inclusive/models/user.dart';
import 'package:inclusive/locator.dart';
import 'package:intl/intl.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final FacebookLogin _facebookSignIn = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
  ]);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final UserModel _userProvider = locator<UserModel>();
  final Geolocator geoLocator = Geolocator();
  String identifier;
  String loginError = '';

  // Email Sign in
  Future<void> signInEmail(String email, String password) async {
    //final AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
    //    email: email, password: password);
  }
  // Phone Sign in

  // Facebook Sign in
  Future<void> signInFacebook() async {
    final FacebookLoginResult result =
        await _facebookSignIn.logIn(<String>['user_birthday']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final String token = result.accessToken.token;
        final Response graphResponse = await get(
            'https://graph.facebook.com/v2.12/me?fields=name,birthday&access_token=$token');
        final Map<String, dynamic> data =
            json.decode(graphResponse.body) as Map<String, dynamic>;
        final AuthCredential credentials =
            FacebookAuthProvider.getCredential(accessToken: token);
        final DateTime birthdate =
            DateFormat.yMd('en_US').parse(data['birthday'] as String);
        login(credentials, data['name'] as String, birthdate);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        loginError = 'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}';
        break;
    }
  }

  // Google Sign in
  Future<void> signInGoogle() async {
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
    } catch (error) {
      print(error);
    }
  }

  // Firebase User login (Email, Phone, Facebook, Google)
  Future<void> login(
      AuthCredential credential, String name, DateTime birthdate) async {
    final AuthResult result =
        await firebaseAuth.signInWithCredential(credential);
    print(result.user.uid);
    print(result.user.displayName);
    print(birthdate);
  }

  // Register from firebase user

  // Stream Firestore User
  Stream<User> streamUser() async* {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo build = await _deviceInfoPlugin.androidInfo;
      identifier = build.androidId;
    } else if (Platform.isIOS) {
      final IosDeviceInfo data = await _deviceInfoPlugin.iosInfo;
      identifier = data.identifierForVendor;
    }
    // testing purpose
    //identifier = 'apmbMHvueWZDLeAOxaxI';
    //identifier = 'cx0hEmwDTLWYy3COnvPL';
    //identifier = 'eDB3PBYE9GTymlTExK80';
    identifier = 'b';
    //identifier = 'f';

    yield* _userProvider.streamUser(identifier);
  }

  Future<void> refreshLocation() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    if (permission == PermissionStatus.unknown) {
      permission = await LocationPermissions().requestPermissions();
    }
    if (permission == PermissionStatus.granted) {
      final Position position = await geoLocator.getCurrentPosition();
      _userProvider.updateLocation(
          GeoPoint(position.latitude, position.longitude), identifier);
    }
  }
}
