import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uwall/utils/colors.dart';
import 'package:uwall/widgets/custom_button.dart';
import 'package:email_validator/email_validator.dart';

import '../../main.dart';
import '../../widgets/custom_textfield.dart';

class SigninScreen extends StatefulWidget {
  static const String routeName = '/signin-screen';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
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
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obsecureText: true,
                  customTextFieldValidator: (value) =>
                      value != null && value.length < 6
                          ? 'Enter a valid password'
                          : null,
                ),
                const SizedBox(height: 20),
                CustomButton(text: 'Sign In', onTap: signIn),
                const SizedBox(height: 24),
                GestureDetector(
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/forgot-password-screen');
                  },
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    text: 'No account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamed('/signup-screen');
                          },
                        text: 'Sign Up',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      Navigator.pop(context);

      //  Utils.showSnackBar(e.message);
    }

    //Navigator.of(context) not working!
    Navigator.of(context).pushNamed('/verify-email-screen');

    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
