import 'package:flutter/material.dart';
import 'package:uwall/screens/category_screen.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:uwall/screens/upload_screen.dart';

import 'screens/auth/signin_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/download_screen.dart';

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

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case UploadScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UploadScreen(),
      );

    case CategoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CategoryScreen(),
      );

    case DownloadScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const DownloadScreen(),
      );

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
