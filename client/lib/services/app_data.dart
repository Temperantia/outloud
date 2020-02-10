import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:inclusive/home.dart';

class AppDataService extends ChangeNotifier {
  int currentPage = 2;

  void navigateBack(BuildContext context, int index) {
    currentPage = index;
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  //coucou

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
