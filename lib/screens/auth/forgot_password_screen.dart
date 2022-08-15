import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password-screen';

  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    const Text(
                      'Enter the email address associated with your account to receive password reset link.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      '(Make sure to check the Spam folder.)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obsecureText: false,
                      customTextFieldValidator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a Valid email'
                              : null,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Reset Password',
                      onTap: resetPassword,
                    ),
                    const SizedBox(height: 8),
                    // CustomButton(
                    //   text: 'Cancel',
                    //   onTap: () => Navigator.pop(context),
                    // ),
                    // const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      //Utils.showSnackBar('Password Reset Email Sent');
      Fluttertoast.showToast(msg: 'Passsword Reset Email Sent');

      //navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Navigator.of(context).pushNamed('/signin-screen');
    } on FirebaseAuthException catch (error) {
      // ignore: avoid_print
      //print(e);
      Fluttertoast.showToast(msg: error.toString());
      // Utils.showSnackBar(e.message);
      Navigator.of(context).pop;
    }
  }
}
