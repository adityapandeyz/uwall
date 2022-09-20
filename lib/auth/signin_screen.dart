import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uwall/auth/forgot_password_screen.dart';
import 'package:uwall/auth/signup_screen.dart';
import 'package:uwall/resources/auth_methods.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:uwall/utils/utils.dart';
import 'package:uwall/widgets/custom_button.dart';
import 'package:email_validator/email_validator.dart';

import '../../widgets/custom_textfield.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                lines: 1,
                controller: _emailController,
                hintText: 'Email',
                obsecureText: false,
                customTextFieldValidator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a Valid email'
                        : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                lines: 1,
                controller: _passwordController,
                hintText: 'Password',
                obsecureText: true,
                customTextFieldValidator: (value) =>
                    value != null && value.length < 6
                        ? 'Enter a valid password'
                        : null,
              ),
              const SizedBox(height: 20),
              CustomButton(text: 'LOGIN', onTap: signIn),
              const SizedBox(height: 24),
              GestureDetector(
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  text: 'No account?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                      text: 'Sign Up',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
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
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Welcome back...');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      showSnackBar(context, res);
    }
    Navigator.pop(context);
    if (res == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }
}
