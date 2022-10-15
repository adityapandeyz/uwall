import 'package:flutter/material.dart';
import 'package:internet_popup/internet_popup.dart';
import '../screens/account_screen.dart';
import '../screens/liked_screen.dart';

import 'category_screen.dart';
import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   InternetPopup().initialize(context: context);
  // }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  final List<Widget> _pages = [
    const FeedScreen(),
    const LikedScreen(),
    const CategoryScreen(),
    const AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        iconSize: 28,
        unselectedItemColor: const Color.fromARGB(87, 255, 255, 255),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_rounded),
            label: 'Liked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
