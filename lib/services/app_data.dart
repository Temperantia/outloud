import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

import 'package:inclusive/classes/user.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/user.dart';

class AppDataService extends ChangeNotifier {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final UserModel userProvider = locator<UserModel>();
  bool loading = true;
  int currentPage = 2;
  String identifier;

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
      final AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
      identifier = build.androidId;
    } else if (Platform.isIOS) {
      final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
      identifier = data.identifierForVendor;
    }
    // testing purpose
    //identifier = 'apmbMHvueWZDLeAOxaxI';
    //identifier = 'cx0hEmwDTLWYy3COnvPL';
    identifier = 'c';

    yield* userProvider.streamUser(identifier);
  }

  Future<PermissionStatus> getLocationPermissions() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    if (permission == PermissionStatus.unknown) {
      permission = await LocationPermissions().requestPermissions();
    }
    return permission;
  }
}
