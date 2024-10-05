import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// A service class for handling media-related operations such as picking images from the gallery.
class MediaService {
  /// Opens the device's gallery to allow the user to pick an image.
  ///
  /// Returns the image as a [Uint8List] if an image is selected successfully, or `null` if the user cancels
  /// the action or an error occurs.
  ///
  /// - The image is read as bytes and returned for further processing (e.g., uploading).
  ///
  /// Example usage:
  /// ```dart
  /// Uint8List? imageData = await MediaService.pickImage();
  /// if (imageData != null) {
  ///   // Process the image data
  /// }
  /// ```
  static Future<Uint8List?> pickImage() async {
    try {
      final imagePicker = ImagePicker();
      // Opens the gallery for the user to pick an image.
      final file = await imagePicker.pickImage(source: ImageSource.gallery);

      if (file != null) {
        // Reads the picked image as bytes.
        return await file.readAsBytes();
      }
    } on PlatformException catch (e) {
      // Logs the error if picking the image fails due to platform restrictions.
      debugPrint('Failed to pick image: $e');
    }
    // Returns null if no image is picked or if an error occurs.
    return null;
  }
}
