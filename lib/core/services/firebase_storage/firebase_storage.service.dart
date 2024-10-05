import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// A service class for handling file uploads to Firebase Storage.
class FirebaseStorageService {
  /// Uploads an image [file] to Firebase Storage at the specified [storagePath].
  ///
  /// Returns the download URL of the uploaded image as a [String].
  ///
  /// - [file]: The image file in `Uint8List` format to be uploaded.
  /// - [storagePath]: The path in Firebase Storage where the image will be stored.
  ///
  /// Example usage:
  /// ```dart
  /// String imageUrl = await FirebaseStorageService.uploadImage(imageFile, 'images/profile_pic.png');
  /// ```
  static Future<String> uploadImage(Uint8List file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putData(file)
          .then((task) => task.ref.getDownloadURL());
}
