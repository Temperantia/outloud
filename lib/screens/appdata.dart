import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:inclusive/services/user.dart';

class AppData {
  static final AppData _appData = AppData._internal();
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Completer completer = Completer();

  String identifier = '';
  User user = User();

  factory AppData() {
    return _appData;
  }

  AppData._internal() {
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

final appData = AppData();
