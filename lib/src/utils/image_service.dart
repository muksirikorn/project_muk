import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> onImageUploading(File imagePath) async {
  final StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('${Uuid().v1()}.png');
  final StorageUploadTask task = firebaseStorageRef.putFile(imagePath);
  StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
  String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}
