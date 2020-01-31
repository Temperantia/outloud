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
import 'package:location_permissions/location_permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final FacebookLogin _facebookSignIn = FacebookLogin();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/user.birthday.read',
  ]);
  final UserModel _userProvider = locator<UserModel>();
  final Geolocator geoLocator = Geolocator();
  String identifier;

  // Email Sign in
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
        final dynamic profile = json.decode(graphResponse.body);
        print(profile);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  // Google Sign in
  Future<void> signInGoogle() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      print(account);
      final Response response = await get(
        'https://people.googleapis.com/v1/people/me'
        '?personFields=birthdays,names',
        headers: await account.authHeaders,
      );
      print('ok');
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      print(data);
    } catch (error) {
      print(error);
    }
  }

  // Firebase User login (Email, Phone, Facebook, Google)
  void login() {
    //FirebaseUser user;
    //user.linkWithCredential()
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
    //identifier = 'b';

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
