import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uwall/screens/download_screen.dart';
import 'package:uwall/widgets/sign_in_widget.dart';

import '../utils/colors.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({Key? key}) : super(key: key);

  @override
  State<LikedScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<LikedScreen> {
  bool isUserLoggedIn = false;
  var postId = [];
  String key = "";
  String wallpaperId = '';

  checkUserLoginState() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isUserLoggedIn = true;
      });
    }
    return isUserLoggedIn;
  }

  @override
  void initState() {
    super.initState();
    checkUserLoginState();
  }

  // getData() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .get()
  //         .then(
  //       (snapshot) async {
  //         if (snapshot.exists) {
  //           snapshot.data()!.forEach((key, value) {
  //             setState(() {
  //               wallpaperId = (snapshot.data()! as dynamic)['favourites'];
  //             });
  //           });

  //           // setState(
  //           //   () {
  //           //     postId =
  //           //   },
  //           // );
  //         }
  //       },
  //     );

  // await FirebaseFirestore.instance
  //     .collection('wallpapers')
  //     .doc()
  //     .get()
  //     .then(
  //   (snapshot) async {
  //     if (snapshot.exists) {
  //       setState(
  //         () {
  //           postId = snapshot.data()!['wallpaperId'];
  //         },
  //       );
  //     }
  //   },
  // );

  //     //     // QuerySnapshot snapshot = await FirebaseFirestore.instance
  //     //     //     .collection('users')
  //     //     //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     //     //     .collection('favourites')
  //     //     //     .get();
  //     //     // List<String> wallpaperIdList = [];

  //     //     // snapshot.docs.forEach((element) {
  //     //     //   String wallpaperId =  ;
  //     //     // });
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  // Map<String, bool> wallpaperId = {};

  // Future<void> getitmeslogin() async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var element in querySnapshot.docs) {
  //       wallpaperId = Map.from(element["favourites"]);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return isUserLoggedIn
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Liked'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('wallpapers')
                    .where('likes',
                        arrayContains: FirebaseAuth.instance.currentUser!.uid)
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
                          // child: Text(postId.toString()),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data!.docs[index]['image'],
                              placeholder: (context, url) =>
                                  Container(color: secondaryColor),
                              fit: BoxFit.cover,
                            ),
                          ),

                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(8),
                          //   child: Image.network(
                          //     snapshot.data!.docs[index]['image'],
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
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
            )

            // const Align(
            //     alignment: Alignment.center,
            //     child: Icon(
            //       Icons.thumb_up_off_alt_rounded,
            //       size: 200,
            //       color: Color.fromARGB(61, 124, 124, 124),
            //     ),
            //   ),
            )
        : const SignInWidget();
  }
}
