import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';

import 'package:inclusive/screens/home.dart';
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
      final Position position = await locator.getCurrentPosition();
      _userProvider.updateLocation(
          GeoPoint(position.latitude, position.longitude), identifier);
    }
  }

  Future<String> saveImage(Uint8List image, String userId) async {
    final StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('images/users/$userId/${DateTime.now()}');
    final StorageUploadTask uploadTask = ref.putData(image);
    final StorageTaskSnapshot result = await uploadTask.onComplete;
    return (await result.ref.getDownloadURL()).toString();
  }

  Future<void> deleteImage(String url, String userId) async {
    (await FirebaseStorage.instance.getReferenceFromUrl(url)).delete();
  }
}
