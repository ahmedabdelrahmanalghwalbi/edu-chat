import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/media/media.service.dart';
import '../../../../core/services/notification/notification.service.dart';
import '../../../../core/util/custom_elevated_button.widget.dart';
import '../../../controllers/auth.controller.dart';

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
              gapH32,
              AutoSizeText(
                AppStrings.createAccount,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              gapH16,
              GestureDetector(
                onTap: () async {
                  final pickedImage = await MediaService.pickImage();
                  setState(() => file = pickedImage!);
                },
                child: file != null
                    ? CircleAvatar(
                        radius: AppSizes.s60,
                        backgroundImage: MemoryImage(file!),
                      )
                    : CircleAvatar(
                        radius: AppSizes.s60,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: const Icon(
                          Icons.add_a_photo,
                          size: AppSizes.s60,
                          color: Colors.white,
                        ),
                      ),
              ),
              gapH24,
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: AppStrings.name,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null && email.isEmpty
                    ? AppStrings.nameCanNotBeEmpty
                    : null,
              ),
              gapH16,
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
              gapH16,
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
              gapH16,
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
              gapH32,
              CustomElevatedButton(
                title: AppStrings.signup,
                onPressed: () async => await AuthController.signUp(
                    context: context,
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    name: nameController.text.trim(),
                    file: file,
                    formKey: formKey,
                    notifications: notifications),
                isPrimaryBackground: false,
              ),
              gapH26,
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
}
