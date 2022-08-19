import 'package:flutter/material.dart';
import 'package:uwall/screens/about_app_screen.dart';
import 'package:uwall/screens/auth/verify_email_screen.dart';
import 'package:uwall/screens/category_screen.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:uwall/screens/privacy_policy_screen.dart';
import 'package:uwall/screens/search/search_screen.dart';
import 'package:uwall/screens/submit_feedback_screen.dart';
import 'package:uwall/screens/terms_and_conditions_screen.dart';
import 'package:uwall/screens/upload_screen.dart';

import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/auth/signup_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SigninScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SigninScreen(),
      );

    case SignupScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignupScreen(),
      );

    case ForgotPasswordScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ForgotPasswordScreen(),
      );
    case VerifyEmailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const VerifyEmailScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    // case ProfileScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => const ProfileScreen(),
    //   );

    case UploadScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UploadScreen(),
      );

    case SearchScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SearchScreen(),
      );

    case CategoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CategoryScreen(),
      );

    case SubmitFeedbackScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SubmitFeedbackScreen(),
      );

    case PrivacyPolicyScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PrivacyPolicyScreen(),
      );

    case TermsAndConditionsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TermsAndConditionsScreen(),
      );

    case AboutAppScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AboutAppScreen(),
      );

    // case DownloadScreen.routeName:
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => DownloadScreen(),
    //   );

    // case HomeScreen.routeName:
    //   return PageTransition(
    //     child: const HomeScreen(),
    //     type: PageTransitionType.scale,
    //     settings: routeSettings,
    //   );

    // case UploadScreen.routeName:
    //   return PageTransition(
    //     child: const UploadScreen(),
    //     type: PageTransitionType.scale,
    //     settings: routeSettings,
    //   );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Error',
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: const Text(
              'Error 404',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
              ),
            ),
          ),
        ),
      );
  }
}
