import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uwall/providers/login_state_provider.dart';
import 'package:uwall/providers/user_provider.dart';
import 'package:uwall/screens/home_screen.dart';
import 'utils/colors.dart';

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
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.black,

      // statusBarColor: Colors.black,
      // statusBarIconBrightness: Brightness.dark,
      // statusBarBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => LoginStateProvider(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Uwall',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          primaryColor: primaryColor,
          textTheme: TextTheme(
            bodyText1: GoogleFonts.getFont('Montserrat'),
            bodyText2: GoogleFonts.getFont('Montserrat'),
            caption: GoogleFonts.getFont('Montserrat'),
          ),
          appBarTheme: AppBarTheme(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 0, 0, 0),
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.light,
            ),
            elevation: 0,
            centerTitle: false,
            color: secondaryColor,
            titleTextStyle: GoogleFonts.getFont('Montserrat'),
          ),
        ),
        home: AnimatedSplashScreen(
          duration: 3000,
          splashIconSize: 175,
          splash: 'assets/logo/uwall_logo_512px.png',
          nextScreen: const NextScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
            } else if (snapshot.hasData) {
              return const HomeScreen();
            }
            const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('No Connection!'),
            );
          }

          return const HomeScreen();
        },
      ),
    );
  }
}
