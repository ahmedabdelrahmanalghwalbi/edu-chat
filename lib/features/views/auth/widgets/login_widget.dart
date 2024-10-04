import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/util/custom_elevated_button.widget.dart';
import '../../../../core/services/notification/notification_legacy.service.dart';
import '../../../controllers/auth.controller.dart';

class LoginWidget extends StatefulWidget {
  final Function() onClickedSignUp;
  const LoginWidget({
    super.key,
    required this.onClickedSignUp,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static final notifications = NotificationsService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              Image.asset(
                AppImages.appIcon,
                fit: BoxFit.contain,
                height: AppSizes.s150,
                width: AppSizes.s150,
              ),
              gapH16,
              // Login Page Headline
              AutoSizeText(
                AppStrings.loginTo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              AutoSizeText(
                AppStrings.yourAccount,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              gapH32,
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: AppStrings.yourEmail,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? AppStrings.enterValidEmail
                        : null,
              ),
              gapH20,
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: AppStrings.password,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? AppStrings.enterMinimum6Chars
                    : null,
              ),
              gapH36,
              CustomElevatedButton(
                title: AppStrings.login,
                onPressed: () async => await AuthController.signIn(
                    context: context,
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    formKey: formKey,
                    notifications: notifications),
                isPrimaryBackground: false,
              ),
              gapH32,
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: AppSizes.s16),
                  text: AppStrings.noAccount,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: AppStrings.signup,
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
