import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uwall/screens/about_app_screen.dart';
import 'package:uwall/screens/download_screen.dart';
import 'package:uwall/screens/search_screen.dart';
import 'package:uwall/utils/colors.dart';
import 'package:uwall/utils/utils.dart';
import 'package:uwall/widgets/sign_in_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, top: 8, bottom: 8, right: 0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AboutAppScreen(),
                  ),
                ),
                child: const CircleAvatar(
                  radius: 13,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage(
                      'assets/logo/uwall_logo_512px.png',
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'Uwall',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const SearchScreen(),
                    ),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                  ),
                ),
              ),
            ],
            // bottom: const TabBar(
            //   isScrollable: true, // Required
            //   unselectedLabelColor: Colors.white30, // Other tabs color
            //   labelPadding:
            //       EdgeInsets.symmetric(horizontal: 30), // Space between tabs
            //   indicator: UnderlineTabIndicator(
            //     borderSide:
            //         BorderSide(color: Colors.white, width: 2), // Indicator height
            //     insets: EdgeInsets.symmetric(horizontal: 48), // Indicator width
            //   ),
            //   tabs: [
            //     Tab(
            //       icon: Icon(Icons.trending_up_rounded),
            //     ),
            //     Tab(
            //       icon: Icon(Icons.supervisor_account_rounded),
            //     ),
            //   ],
            // ),
          ),
          body: const PopularScreen()
          // body: const TabBarView(
          //   children: [
          //     PopularScreen(),
          //     FollowedScreen(),
          //   ],
          // ),
          ),
    );
  }
}

class PopularScreen extends StatelessWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Popular',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('wallpapers')
                  .orderBy('downloads', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    crossAxisCount: 3,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                    if (snapshot.data!.docs.length != null) {
                      return GestureDetector(
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DownloadScreen(
                                wallpaperId: snapshot.data!.docs[index]
                                    ['wallpaperId'],
                                downloads: snapshot.data!.docs[index]
                                    ['downloads'],
                              ),
                            ),
                          );
                        }),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!.docs[index]['image'],
                            placeholder: (context, url) =>
                                Container(color: secondaryColor),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        'Something went wrong...',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FollowedScreen extends StatefulWidget {
  const FollowedScreen({Key? key}) : super(key: key);

  @override
  State<FollowedScreen> createState() => _FollowedScreenState();
}

class _FollowedScreenState extends State<FollowedScreen> {
  List following = [];
  bool isLoading = false;

  bool isUserLoggedIn = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    checkUserLoginState();
  }

  checkUserLoginState() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isUserLoggedIn = true;
      });
      getData();
    }
    return isUserLoggedIn;
  }

  getData() async {
    setState(
      () {
        isLoading = true;
      },
    );
    try {
      // user data
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (snapshot) async {
          if (snapshot.exists) {
            setState(
              () {
                following = snapshot.data()!['followers'];
              },
            );
          }
        },
      );

      setState(() {});
    } catch (error) {
      showSnackBar(
        context,
        error.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isUserLoggedIn
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Followed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('wallpapers')
                        .orderBy('downloads', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          crossAxisCount: 3,
                          mainAxisExtent: 250,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          const Center(
                            child: CircularProgressIndicator(),
                          );
                          if (following.contains(
                            snapshot.data!.docs[index]['uid'],
                          )) {
                            if (snapshot.data!.docs.length != null) {
                              return GestureDetector(
                                onTap: (() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DownloadScreen(
                                        wallpaperId: snapshot.data!.docs[index]
                                            ['wallpaperId'],
                                        downloads: snapshot.data!.docs[index]
                                            ['downloads'],
                                      ),
                                    ),
                                  );
                                }),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.docs[index]
                                        ['image'],
                                    placeholder: (context, url) =>
                                        Container(color: secondaryColor),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          }
                          return const Center(
                            child: Text(
                              'Something went wrong...',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : SignInWidget();
  }
}
