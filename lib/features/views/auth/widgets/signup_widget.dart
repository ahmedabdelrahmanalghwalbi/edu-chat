import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../main.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/firebase_firestore/firebase_firestore.service.dart';
import '../../../../core/services/firebase_storage/firebase_storage.service.dart';
import '../../../../core/services/media/media.service.dart';
import '../../../../core/services/notification/notification.service.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpWidget({
    super.key,
    required this.onClickedSignIn,
  });

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Uint8List? file;
  static final notifications = NotificationsService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () async {
                  final pickedImage = await MediaService.pickImage();
                  setState(() => file = pickedImage!);
                },
                child: file != null
                    ? CircleAvatar(
                        radius: AppSizes.s50,
                        backgroundImage: MemoryImage(file!),
                      )
                    : CircleAvatar(
                        radius: AppSizes.s50,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(
                          Icons.add_a_photo,
                          size: AppSizes.s50,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: AppSizes.s20),
              const SizedBox(height: AppSizes.s40),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: AppStrings.name,
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null && email.isEmpty
                    ? AppStrings.nameCanNotBeEmpty
                    : null,
              ),
              const SizedBox(height: AppSizes.s20),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: AppStrings.yourEmail,
                  border: OutlineInputBorder(),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? AppStrings.enterValidEmail
                        : null,
              ),
              const SizedBox(height: AppSizes.s20),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: AppStrings.password,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? AppStrings.enterMinimum6Chars
                    : null,
              ),
              const SizedBox(height: AppSizes.s20),
              TextFormField(
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: AppStrings.confirmPassword,
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    passwordController.text != confirmPasswordController.text
                        ? AppStrings.passwordMustMatch
                        : null,
              ),
              const SizedBox(height: AppSizes.s20),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(AppSizes.s50),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: AppSizes.s32),
                  label: const Text(
                    AppStrings.signup,
                    style: TextStyle(fontSize: AppSizes.s24),
                  ),
                  onPressed: signUp),
              const SizedBox(height: AppSizes.s20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black, fontSize: AppSizes.s20),
                  text: AppStrings.alreadyHaveAnAccount,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: AppStrings.login,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future signUp() async {
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
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final image = await FirebaseStorageService.uploadImage(
          file!, 'image/profile/${user.user!.uid}');

      await FirebaseFirestoreService.createUser(
        image: image,
        email: user.user!.email!,
        uid: user.user!.uid,
        name: nameController.text,
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
