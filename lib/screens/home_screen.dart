import 'package:flutter/material.dart';
import 'package:uwall/screens/account_screen.dart';
import 'package:uwall/screens/category_screen.dart';
import 'package:uwall/screens/feed_screen.dart';
import 'package:uwall/screens/liked_screen.dart';
import 'package:uwall/screens/upload_screen.dart';
import 'package:uwall/utils/colors.dart';
import 'package:bottom_navigation_view/bottom_navigation_view.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _currentIndex = 0;
//   late PageController pageController;

//   @override
//   void initState() {
//     super.initState();
//     pageController = PageController();
//   }

//   void onPageChanged(int value) {
//     setState(() => _currentIndex = value);
//   }

//   void navigationTapped(int value) {
//     //Animating Page
//     pageController.jumpToPage(value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         physics: const NeverScrollableScrollPhysics(),
//         controller: pageController,
//         onPageChanged: onPageChanged,
//         children: const [
//           FeedScreen(),
//           LikedScreen(),
//           UploadScreen(),
//           CategoryScreen(),
//           AccountScreen(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: backgroundColor,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: primaryColor,
//         unselectedItemColor: Colors.white.withOpacity(.60),
//         iconSize: 30,
//         selectedFontSize: 11,
//         unselectedFontSize: 11,
//         onTap: navigationTapped,
//         currentIndex: _currentIndex,
//         items: const [
//           BottomNavigationBarItem(
//             label: '',
//             icon: Icon(
//               (Icons.home),
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: '',
//             icon: Icon(
//               (Icons.thumb_up_alt_rounded),
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: '',
//             icon: Icon(
//               (Icons.add_circle_outline_sharp),
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: '',
//             icon: Icon(
//               (Icons.category),
//             ),
//           ),
//           BottomNavigationBarItem(
//             label: '',
//             icon: Icon(
//               (Icons.account_circle_outlined),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final BottomNavigationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BottomNavigationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _controller.goBack();
        return false;
      },
      child: Scaffold(
        body: BottomNavigationView(
          controller: _controller,
          transitionType: BottomNavigationTransitionType.fadeInOut,
          backgroundColor: Colors.lime,
          children: const [
            // ColorScreen(color: Colors.red),
            // ColorScreen(color: Colors.amber),
            // ColorScreen(color: Colors.yellow),
            // ColorScreen(color: Colors.green),
            // ColorScreen(color: Colors.blue),

            FeedScreen(),
            LikedScreen(),
            UploadScreen(),
            CategoryScreen(),
            AccountScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationIndexedBuilder(
          controller: _controller,
          builder: (context, index, child) {
            return BottomNavigationBar(
              currentIndex: index,
              onTap: (index) {
                _controller.goTo(index);
              },
              type: BottomNavigationBarType.fixed,
              iconSize: 28,
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color.fromARGB(87, 255, 255, 255),
              backgroundColor: Colors.black,
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
            );
          },
        ),
      ),
    );
  }
}

// class ColorScreen extends StatefulWidget {
//   const ColorScreen({
//     Key? key,
//     required this.color,
//   }) : super(key: key);

//   final Color color;

//   @override
//   State<ColorScreen> createState() => _ColorScreenState();
// }

// class _ColorScreenState extends State<ColorScreen> {
//   int count = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.center,
//       color: widget.color,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             '$count',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 count++;
//               });
//             },
//             child: const Text('Increment'),
//           ),
//         ],
//       ),
//     );
//   }
// }
