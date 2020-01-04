import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/locator.dart';
import 'package:inclusive/models/userModel.dart';

class AppDataService extends ChangeNotifier {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final UserModel userProvider = locator<UserModel>();

  String identifier;
  User user;

  Stream<User> getUser() async* {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      identifier = build.androidId;

      // testing purpose
      identifier = 'apmbMHvueWZDLeAOxaxI';
      //identifier = 'cx0hEmwDTLWYy3COnvPL';

    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      identifier = data.identifierForVendor;
    }
    yield* userProvider.streamUser(identifier);
  }
}
