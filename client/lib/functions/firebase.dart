import 'dart:typed_data';
import 'package:business/app.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> saveImage(Uint8List image, String path) async {
  final StorageReference ref =
      firebaseStorage.ref().child('$path/${DateTime.now()}');
  final StorageUploadTask uploadTask = ref.putData(image);
  final StorageTaskSnapshot result = await uploadTask.onComplete;
  return (await result.ref.getDownloadURL()).toString();
}
