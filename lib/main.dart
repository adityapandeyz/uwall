import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uwall/router.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';

import 'utils/colors.dart';
import 'widgets/side_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCP5ikTZ084MC9gpre8ViDKFvm5IhQC2RY",
        appId: "1:211849169385:web:961bfc73325f8d9a56a378",
        messagingSenderId: "211849169385",
        projectId: "uwall-dotresolution",
        storageBucket: "uwall-dotresolution.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'uwall',
      navigatorKey: navigatorKey,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
              ),
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: backgroundColor,
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: AnimatedSplashScreen(
        duration: 3000,
        splashIconSize: 175,
        splash: 'assets/logo/uwall_logo_512px.png',
        nextScreen: const HomeScreen(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else if (snapshot.hasData) {
            return const LogedInDrawer();
          } else {
            return const LogedOutDrawer();
          }
        },
      ),
    );
  }
}
