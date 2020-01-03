import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/userModel.dart';

class AppDataService extends ChangeNotifier {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final UserModel userProvider = locator<UserModel>();
  final Completer completer = Completer();

  String identifier = '';
  User user = User();

  AppDataService() {
    if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((build) {
        identifier = build.androidId;

        // testing purpose
        identifier = 'apmbMHvueWZDLeAOxaxI';
        //identifier = 'cx0hEmwDTLWYy3COnvPL';

        completer.complete();
      });
    } else if (Platform.isIOS) {
      deviceInfoPlugin.iosInfo.then((data) {
        identifier = data.identifierForVendor;
        completer.complete();
      });
    }
  }

  Future<User> getUser() async {
    await completer.future;
    return userProvider.getUser(identifier);
  }
}
