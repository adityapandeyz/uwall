import 'package:flutter/material.dart';
import 'package:uwall/screens/account_screen.dart';
import 'package:uwall/screens/category_screen.dart';
import 'package:uwall/screens/feed_screen.dart';
import 'package:uwall/screens/liked_screen.dart';
import 'package:uwall/screens/upload_screen.dart';
import 'package:uwall/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int value) {
    setState(() => _currentIndex = value);
  }

  void navigationTapped(int value) {
    //Animating Page
    pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: const [
          FeedScreen(),
          LikedScreen(),
          UploadScreen(),
          CategoryScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: backgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.white.withOpacity(.60),
        iconSize: 30,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: navigationTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              (Icons.home),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              (Icons.thumb_up_alt_rounded),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              (Icons.add_circle_outline_sharp),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              (Icons.category),
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              (Icons.account_circle_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
