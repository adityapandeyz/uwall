import 'package:flutter/material.dart';
import 'package:uwall/auth/signin_screen.dart';

import 'custom_rectangle.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.report_problem_rounded,
            size: 200,
            color: Colors.yellow,
          ),
          const Text('You must be logged in to access this screen!'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomRectangle(
              icon: Icons.account_circle_outlined,
              child: const Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ontap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SigninScreen(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
