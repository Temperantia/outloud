import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:business/classes/user.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Geolocator geoLocator = Geolocator();
  String identifier;
  String loginError = '';

  // Email Sign in
  Future<void> signInEmail(String email, String password) async {
    //final AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
    //    email: email, password: password);
  }
  // Phone Sign in

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

    //yield* _userProvider.streamUser(identifier);
  }

  Future<void> refreshLocation() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    if (permission == PermissionStatus.unknown) {
      permission = await LocationPermissions().requestPermissions();
    }
    if (permission == PermissionStatus.granted) {
      //final Position position = await geoLocator.getCurrentPosition();
      //_userProvider.updateLocation(
      //  GeoPoint(position.latitude, position.longitude), identifier);
    }
  }
}
