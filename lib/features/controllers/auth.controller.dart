import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/firebase_firestore/firebase_firestore.service.dart';
import '../../core/services/firebase_storage/firebase_storage.service.dart';
import '../../core/services/notification/notification_legacy.service.dart';
import '../../main.dart';

/// An abstract class that handles authentication tasks such as signing in and signing up
/// using Firebase Authentication. It also integrates with Firestore and Firebase Storage
/// for user data and profile picture handling.
abstract class AuthController {
  /// Signs in a user with email and password.
  ///
  /// This method validates the form using [formKey], then attempts to sign in using
  /// Firebase Authentication. Upon successful sign-in, it updates the user's `lastActive` field
  /// in Firestore and navigates back to the main screen.
  ///
  /// If the sign-in fails due to a [FirebaseAuthException], an error message will be displayed
  /// in a snackbar.
  ///
  /// Parameters:
  /// - [context]: The current BuildContext used for navigation and displaying snackbars.
  /// - [email]: The user's email for sign-in.
  /// - [password]: The user's password for sign-in.
  /// - [formKey]: A [GlobalKey] for the form to validate input fields.
  /// - [notifications]: The service used for handling push notifications.
  static Future signIn({
    required BuildContext context,
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
    required NotificationsService notifications,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      // Sign in with FirebaseAuth
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Update the last active field in Firestore
      await FirebaseFirestoreService.updateUserData(
        {'lastActive': DateTime.now()},
      );

      // TODO: Implement push notification service
      // await notifications.requestPermission();
      // await notifications.getToken();
    } on FirebaseAuthException catch (e) {
      // Display error message in a snackbar
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Navigate to the first route in the navigation stack
    navigatorKey.currentState!.popUntil(((route) => route.isFirst));
  }

  /// Signs up a new user with email, password, and name.
  ///
  /// This method first validates the form using [formKey] and checks if a profile picture
  /// is selected. It creates a new user in Firebase Authentication, uploads the profile picture
  /// to Firebase Storage, and creates the user record in Firestore.
  ///
  /// If any error occurs (e.g., missing profile picture or FirebaseAuthException), the user will
  /// see an appropriate error message in a snackbar.
  ///
  /// Parameters:
  /// - [context]: The current BuildContext used for navigation and displaying snackbars.
  /// - [email]: The user's email for sign-up.
  /// - [password]: The user's password for sign-up.
  /// - [name]: The user's name.
  /// - [file]: The profile picture file as [Uint8List].
  /// - [formKey]: A [GlobalKey] for the form to validate input fields.
  /// - [notifications]: The service used for handling push notifications.
  static Future signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required Uint8List? file,
    required GlobalKey<FormState> formKey,
    required NotificationsService notifications,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    // Check if the profile picture is selected
    if (file == null) {
      const snackBar =
          SnackBar(content: Text(AppStrings.pleaseSelectProfilePicture));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      // Create a new user in FirebaseAuth
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Upload the profile picture to Firebase Storage
      final image = await FirebaseStorageService.uploadImage(
          file, 'image/profile/${user.user!.uid}');

      // Create user record in Firestore
      await FirebaseFirestoreService.createUser(
        image: image,
        email: user.user!.email!,
        uid: user.user!.uid,
        name: name,
      );

      // TODO: Implement push notification service
      // await notifications.requestPermission();
      // await notifications.getToken();
    } on FirebaseAuthException catch (e) {
      // Display error message in a snackbar
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Navigate to the first route in the navigation stack
    navigatorKey.currentState!.popUntil(((route) => route.isFirst));
  }
}
