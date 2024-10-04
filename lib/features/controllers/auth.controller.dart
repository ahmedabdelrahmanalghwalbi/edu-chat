import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/firebase_firestore/firebase_firestore.service.dart';
import '../../core/services/firebase_storage/firebase_storage.service.dart';
import '../../core/services/notification/notification.service.dart';
import '../../main.dart';

abstract class AuthController {
  static Future signIn({
    required BuildContext context,
    required String email,
    required String password,
    required GlobalKey<FormState> formKey,
    required NotificationsService notifications,
  }) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestoreService.updateUserData(
        {'lastActive': DateTime.now()},
      );

      await notifications.requestPermission();
      await notifications.getToken();
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    navigatorKey.currentState!.popUntil(((route) => route.isFirst));
  }

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
    if (file == null) {
      const snackBar =
          SnackBar(content: Text(AppStrings.pleaseSelectProfilePicture));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final image = await FirebaseStorageService.uploadImage(
          file, 'image/profile/${user.user!.uid}');

      await FirebaseFirestoreService.createUser(
        image: image,
        email: user.user!.email!,
        uid: user.user!.uid,
        name: name,
      );

      await notifications.requestPermission();
      await notifications.getToken();
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    navigatorKey.currentState!.popUntil(((route) => route.isFirst));
  }
}
