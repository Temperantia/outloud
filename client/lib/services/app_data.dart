import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AppDataService extends ChangeNotifier {
  static Future<void> checkInternetConnection() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw Exception();
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
