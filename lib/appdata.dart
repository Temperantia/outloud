import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:inclusive/models/userModel.dart';

class AppData extends ChangeNotifier {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Completer completer = Completer();

  String identifier = '';
  User user = User();

  AppData() {
    if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo
          .then((build) {
            identifier = build.androidId;
            completer.complete();
          });
    } else if (Platform.isIOS) {
      deviceInfoPlugin.iosInfo
          .then((data) {
            identifier = data.identifierForVendor;
            completer.complete();
          });
    }
  }
}

