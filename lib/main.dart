import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/home_screen.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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
          splash: 'assets/logo/ic_launcher/play_store_512.png',
          nextScreen: const NextScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}

class NextScreen extends StatefulWidget {
  const NextScreen({Key? key}) : super(key: key);

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  @override
  void initState() {
    super.initState();
    InternetPopup().initialize(context: context);
  }

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
