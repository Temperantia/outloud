import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inclusive/screens/home.dart';
import 'package:location_permissions/location_permissions.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/locator.dart' as loc;
import 'package:inclusive/models/user.dart';

class AppDataService extends ChangeNotifier {
  final UserModel _userProvider = loc.locator<UserModel>();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final Geolocator locator = Geolocator();

  int currentPage = 2;
  String identifier;

  void navigateBack(BuildContext context, int index) {
    currentPage = index;
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  static Future<bool> checkInternet() async {
    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Stream<User> getUser() async* {
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
    identifier = 'b';

    yield* _userProvider.streamUser(identifier);
  }

  Future<void> refreshLocation() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    if (permission == PermissionStatus.unknown) {
      permission = await LocationPermissions().requestPermissions();
    }
    if (permission == PermissionStatus.granted) {
      final Position position = await locator.getCurrentPosition();
      _userProvider.updateLocation(
          GeoPoint(position.latitude, position.longitude), identifier);
    }
  }
}
