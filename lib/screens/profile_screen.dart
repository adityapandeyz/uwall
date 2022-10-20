import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:scale_button/scale_button.dart';
import 'package:uwall/widgets/user_tile.dart';
import '../screens/home_screen.dart';
import '../utils/utils.dart';
import '../widgets/custom_rectangle.dart';
import '../widgets/empty_warning.dart';
import '../widgets/sign_in_widget.dart';
import '../widgets/square_box.dart';

import '../auth/signin_screen.dart';
import '../utils/colors.dart';
import 'download_screen.dart';

// class ProfileScreen extends StatefulWidget {
//   final String userId;
//   const ProfileScreen({
//     Key? key,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool isUserLoggedIn = false;

//   checkUserLoginState() {
//     if (FirebaseAuth.instance.currentUser != null) {
//       setState(() {
//         isUserLoggedIn = true;
//       });
//     }
//     return isUserLoggedIn;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return checkUserLoginState()
//         ? ProfileScreen(
//             userId: widget.userId,
//           )
//         : const SignInWidget();
//   }
// }

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? fullName = "";
  String? email = "";
  String? image = "";
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isAnotherUser = true;
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
          .doc(widget.userId)
          .get()
          .then(
        (snapshot) async {
          if (snapshot.exists) {
            setState(
              () {
                fullName = snapshot.data()!['fullName'];
                email = snapshot.data()!['email'];
                image = snapshot.data()!['photoUrl'];
                followers = snapshot.data()!['followers'].length;
                following = snapshot.data()!['following'].length;

                isFollowing = snapshot
                    .data()!['followers']
                    .contains(FirebaseAuth.instance.currentUser!.uid);
              },
            );
          }
        },
      );

      // isFollowing = userSnap
      //     .data()!['followers']
      //     .contains(FirebaseAuth.instance.currentUser!.uid);

      // // get post
      var postSnap = await FirebaseFirestore.instance
          .collection('wallpapers')
          .where('uid', isEqualTo: widget.userId)
          .get();

      postLen = postSnap.docs.length;

      // setState(() {
      //   userData = userSnap.data()!;

      // });

      if (FirebaseAuth.instance.currentUser!.uid == widget.userId) {
        setState(() {
          isAnotherUser = false;
        });
      }

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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                    (Route<dynamic> route) => false),
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            body: isUserLoggedIn
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 20),
                            // CircleAvatar(
                            //   radius: 40,
                            //   backgroundImage: NetworkImage(image!),
                            // ),
                            InstaImageViewer(
                              child: CircleAvatar(
                                radius: 44,
                                backgroundImage: Image.network(
                                  image!,
                                ).image,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              fullName!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              email!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(87, 158, 158, 158),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SquareBox(
                                  onTap: () => widget.userId ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const MyPosts(),
                                          ),
                                        )
                                      : null,
                                  height: 60,
                                  width: 100,
                                  bColor:
                                      const Color.fromARGB(66, 68, 137, 255),
                                  title: '$postLen',
                                  subtitle: 'Posts',
                                ),
                                SquareBox(
                                  onTap: () => widget.userId ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const MyFollowers(),
                                          ),
                                        )
                                      : null,
                                  height: 60,
                                  width: 100,
                                  bColor: const Color.fromARGB(66, 255, 38, 0),
                                  title: '$followers',
                                  subtitle: 'Followers',
                                ),
                                SquareBox(
                                  onTap: () => widget.userId ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MyFollowings(),
                                          ),
                                        )
                                      : null,
                                  height: 60,
                                  width: 100,
                                  bColor: const Color.fromARGB(66, 72, 255, 0),
                                  title: '$following',
                                  subtitle: 'Following',
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            isUserLoggedIn
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: isAnotherUser
                                        ? Container(
                                            child: isFollowing
                                                ? CustomRectangle(
                                                    forwardIcon: false,
                                                    leadingIcon: false,
                                                    isCenter: true,
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons
                                                            .person_add_alt_1_rounded),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Following',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ontap: () async {
                                                      try {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) =>
                                                              const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          'following':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            widget.userId
                                                          ]),
                                                        });

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(widget.userId)
                                                            .update({
                                                          'followers':
                                                              FieldValue
                                                                  .arrayRemove([
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                          ]),
                                                        });

                                                        showSnackBar(context,
                                                            'Unfollowed successfuly!');

                                                        setState(() {
                                                          isFollowing = false;
                                                        });
                                                      } on PlatformException catch (error) {
                                                        showSnackBar(context,
                                                            error.toString());
                                                      }
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  )
                                                : CustomRectangle(
                                                    forwardIcon: false,
                                                    leadingIcon: false,
                                                    isCenter: true,
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons
                                                            .person_add_alt_1_outlined),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          'Follow',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ontap: () async {
                                                      try {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) =>
                                                              const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          'following':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            widget.userId
                                                          ]),
                                                        });

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(widget.userId)
                                                            .update({
                                                          'followers':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                          ]),
                                                        });

                                                        showSnackBar(context,
                                                            'You are following this user!');

                                                        setState(() {
                                                          isFollowing = true;
                                                        });
                                                      } on PlatformException catch (error) {
                                                        showSnackBar(context,
                                                            error.toString());
                                                      }
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                  ),
                                          )
                                        : Container(),
                                  )
                                : CustomRectangle(
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
                            const SizedBox(height: 10),
                            const Divider(color: Colors.grey),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('wallpapers')
                                  .where("uid", isEqualTo: widget.userId)
                                  // .orderBy('createdAt', descending: true)
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.docs.isEmpty) {
                                      return const EmptyWarning(
                                        text: 'No Posts!',
                                        icon: Icons.no_photography_outlined,
                                      );
                                    }
                                    return GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        crossAxisCount: 3,
                                        mainAxisExtent: 150,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ScaleButton(
                                          bound: 0.05,
                                          duration:
                                              const Duration(milliseconds: 170),
                                          onTap: (() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => DownloadScreen(
                                                  wallpaperId:
                                                      snapshot.data!.docs[index]
                                                          ['wallpaperId'],
                                                  downloads: snapshot.data!
                                                      .docs[index]['downloads'],
                                                ),
                                              ),
                                            );
                                          }),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data!.docs[index]['image'],
                                              placeholder: (context, url) =>
                                                  Container(
                                                      color: secondaryColor),
                                              fit: BoxFit.cover,
                                            ),
                                          ),

                                          // ClipRRect(
                                          //   borderRadius:
                                          //       BorderRadius.circular(8),
                                          //   child: Image.network(
                                          //     snapshot.data!.docs[index]
                                          //         ['image'],
                                          //     fit: BoxFit.cover,
                                          //   ),
                                          // ),
                                        );
                                      },
                                    );
                                  }

                                  return const Center(
                                    child: Text(
                                      'No Posts.',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text(
                                      'No Connection!',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                // ignore: prefer_const_constructors
                : SignInWidget(),
          );
  }
}

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wallpapers')
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.isEmpty) {
                return const EmptyWarning(
                  text: 'No Posts!',
                  icon: Icons.no_photography_outlined,
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 3,
                  mainAxisExtent: 150,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ScaleButton(
                    bound: 0.05,
                    duration: const Duration(milliseconds: 170),
                    onTap: (() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DownloadScreen(
                            wallpaperId: snapshot.data!.docs[index]
                                ['wallpaperId'],
                            downloads: snapshot.data!.docs[index]['downloads'],
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
                },
              );
            }

            return const Center(
              child: Text(
                'No Connection.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No Connection!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class MyFollowers extends StatelessWidget {
  const MyFollowers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Followers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(
              'following',
              arrayContains: FirebaseAuth.instance.currentUser!.uid,
            )

            // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.isEmpty) {
                return const EmptyWarning(
                  text: 'No Followers',
                  icon: Icons.person_off_rounded,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.docs.length != null) {
                    return UserTile(
                      photoUrl: snapshot.data!.docs[index]['photoUrl'],
                      name: snapshot.data!.docs[index]['fullName'],
                      // postCount: '12',
                      userId: snapshot.data!.docs[index]['uid'],
                    );
                  }
                  return const Center(
                    child: Text(
                      'No Posts.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text(
                'No Connection.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No Connection!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class MyFollowings extends StatelessWidget {
  const MyFollowings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Following'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(
              'followers',
              arrayContains: FirebaseAuth.instance.currentUser!.uid,
            )

            // .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.isEmpty) {
                return const EmptyWarning(
                  text: 'No Following',
                  icon: Icons.person_off_rounded,
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return UserTile(
                    photoUrl: snapshot.data!.docs[index]['photoUrl'],
                    name: snapshot.data!.docs[index]['fullName'],
                    // postCount: snapshot.data!.docs.length,
                    userId: snapshot.data!.docs[index]['uid'],
                  );
                },
              );
            }

            return const Center(
              child: Text(
                'No Connection.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No Connection!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
