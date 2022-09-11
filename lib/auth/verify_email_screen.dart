import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:uwall/utils/utils.dart';
import 'package:uwall/widgets/custom_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    /// user needs to be created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    //Call after email verificaton
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomeScreen()
      : Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      "A verficatoin Email has been sent to your email.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      "(Make sure to check spam folder.)",
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      text: 'Resent Email',
                      onTap: () {
                        canResendEmail ? sendVerificationEmail : null;
                      },
                    ),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //       minimumSize: const Size.fromHeight(50),
                    //       surfaceTintColor: secondaryColor),
                    //   onPressed: canResendEmail ? sendVerificationEmail : null,
                    //   child: const Text(
                    //     'Resent Email',
                    //   ),
                    // ),
                    const SizedBox(
                      height: 2,
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 21),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then(
                              (res) {},
                            );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
}
