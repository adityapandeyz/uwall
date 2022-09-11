import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:uwall/screens/profile_screen.dart';
import 'package:uwall/screens/liked_screen.dart';
import 'package:uwall/utils/utils.dart';
import 'package:uwall/widgets/custom_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:uwall/widgets/custom_rectangle.dart';

import '../auth/signin_screen.dart';

class DownloadScreen extends StatefulWidget {
  final String wallpaperId;
  final int? downloads;

  const DownloadScreen({
    Key? key,
    required this.downloads,
    required this.wallpaperId,
  }) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  int? total;
  String imageTitle = '';

  bool isUserLoggedIn = false;
  bool isLiked = false;

  checkUserLoginState() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isUserLoggedIn = true;
      });
      getData();
    }
    return isUserLoggedIn;
  }

  @override
  void initState() {
    super.initState();
    checkUserLoginState();
    getPostTitle();
  }

  getPostTitle() async {
    try {
      var postSnap1 = await FirebaseFirestore.instance
          .collection('wallpapers')
          .doc(widget.wallpaperId)
          .get();

      setState(() {
        imageTitle = postSnap1.data()!['title'];
      });
    } catch (error) {
      showSnackBar(
        context,
        error.toString(),
      );
    }
  }

  getData() async {
    try {
      var postSnap2 = await FirebaseFirestore.instance
          .collection('wallpapers')
          .doc(widget.wallpaperId)
          .get();
      isLiked = postSnap2
          .data()!['likes']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('wallpapers')
                  .where("wallpaperId", isEqualTo: widget.wallpaperId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 160.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.45,
                              child: InstaImageViewer(
                                child: Image(
                                  image: Image.network(
                                    snapshot.data!.docs[index]['image'],
                                  ).image,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                snapshot.data!.docs[index]['fullName']
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                snapshot.data!.docs[index]['description']
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(87, 255, 255, 255),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomRectangle(
                            leadingIcon: false,
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'About',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                          snapshot.data!.docs[index]
                                              ['userImage'],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]['fullName']
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['email']
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                87, 255, 255, 255),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProfileScreen(
                                    userId: snapshot.data!.docs[index]['uid'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        isUserLoggedIn
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: isLiked
                                    ? CustomRectangle(
                                        forward_icon: false,
                                        leadingIcon: false,
                                        isCenter: true,
                                        ontap: () async {
                                          try {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );

                                            FirebaseFirestore.instance
                                                .collection('wallpapers')
                                                .doc(snapshot.data!.docs[index]
                                                    ['wallpaperId'])
                                                .update({
                                              'likes': FieldValue.arrayRemove([
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                              ]),
                                            }).then(
                                              (value) {
                                                Navigator.canPop(context)
                                                    ? Navigator.pop(context)
                                                    : null;

                                                showSnackBar(context,
                                                    'You unliked this wallpaper!');

                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const HomeScreen(),
                                                  ),
                                                );
                                              },
                                            );
                                            setState(() {
                                              isLiked = false;
                                            });
                                          } on PlatformException catch (error) {
                                            Navigator.pop(context);

                                            showSnackBar(
                                                context, error.toString());
                                          }
                                        },
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Icon(Icons.thumb_up_alt_rounded),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Liked',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )

                                        //  CustomButton(
                                        //   text: 'Like',
                                        //   onTap: ()
                                        // ),
                                        )
                                    : CustomRectangle(
                                        forward_icon: false,
                                        leadingIcon: false,
                                        isCenter: true,
                                        child: Row(
                                          children: const [
                                            Icon(Icons.thumb_up_alt_outlined),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Like',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ontap: () async {
                                          try {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );

                                            FirebaseFirestore.instance
                                                .collection('wallpapers')
                                                .doc(snapshot.data!.docs[index]
                                                    ['wallpaperId'])
                                                .update({
                                              'likes': FieldValue.arrayUnion([
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                              ]),
                                            }).then(
                                              (value) {
                                                Navigator.canPop(context)
                                                    ? Navigator.pop(context)
                                                    : null;

                                                showSnackBar(context,
                                                    'You liked this wallpaper!');

                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const LikedScreen(),
                                                  ),
                                                );
                                              },
                                            );

                                            setState(() {
                                              isLiked = true;
                                            });
                                          } on PlatformException catch (error) {
                                            Navigator.pop(context);

                                            showSnackBar(
                                                context, error.toString());
                                          }
                                        },
                                      ))
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomRectangle(
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
                              ),
                        const SizedBox(height: 10),
                        isUserLoggedIn
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: CustomButton(
                                  text: 'Download',
                                  onTap: () async {
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );

                                      var response = await Dio().get(
                                        snapshot.data!.docs[index]['image']
                                            .toString(),
                                        options: Options(
                                          responseType: ResponseType.bytes,
                                        ),
                                      );
                                      await ImageGallerySaver.saveImage(
                                        Uint8List.fromList(response.data),
                                      );

                                      showSnackBar(
                                          context, 'Image Saved to Gallery');

                                      total = widget.downloads! + 1;

                                      FirebaseFirestore.instance
                                          .collection('wallpapers')
                                          .doc(snapshot.data!.docs[index]
                                              ['wallpaperId'])
                                          .update({
                                        'downloads': total,
                                      }).then((value) {
                                        Navigator.canPop(context)
                                            ? Navigator.pop(context)
                                            : null;

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const HomeScreen(),
                                          ),
                                        );
                                      });
                                    } on PlatformException catch (error) {
                                      Navigator.pop(context);

                                      showSnackBar(context, error.toString());
                                    }
                                  },
                                ),
                              )
                            : Container(),
                      ],
                    );
                  },
                );
              },
            ),

            // const SizedBox(height: 20),
            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('wallpaper')
            //       .where("createdAt", isEqualTo: clickedImageId)
            //       // .orderBy('createdAt', descending: true)
            //       .snapshots(),
            //   builder: (context, AsyncSnapshot snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     } else if (snapshot.connectionState == ConnectionState.active) {
            //       if (!snapshot.hasData) {
            //         return const Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //       // return Column(
            //       //   children: [
            //       //     Container(
            //       //       width: double.infinity,
            //       //       // height: MediaQuery.of(context).size.height / 2,
            //       //       child: ClipRRect(
            //       //         child: Image.network(snapshot.data!.docs['Image']),
            //       //       ),
            //       //     ),
            //       //   ],
            //       // );
            //       // return CarouselSlider.builder(
            //       //   itemCount: snapshot.data!.docs.length,
            //       //   options: CarouselOptions(
            //       //     // height: 1000,
            //       //     height: 600,
            //       //     aspectRatio: 16 / 9,

            //       //     autoPlay: false,
            //       //     enlargeCenterPage: true,
            //       //   ),
            //       //   itemBuilder: (context, index, realIdx) {
            //       //     return SizedBox(
            //       //       child: Center(
            //       //         child: Image.network(
            //       //           snapshot.data!.docs[index]['Image'],
            //       //           fit: BoxFit.cover,
            //       //           width: 1000,
            //       //         ),
            //       //       ),
            //       //     );
            //       //   },
            //       // );
            //       return GridView.builder(
            //         physics: const NeverScrollableScrollPhysics(),
            //         shrinkWrap: true,
            //         itemCount: snapshot.data!.docs.length,
            //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisSpacing: 5,
            //           mainAxisSpacing: 5,
            //           crossAxisCount: 3,
            //           mainAxisExtent: 150,
            //         ),
            //         itemBuilder: (BuildContext context, int index) {
            //           return GestureDetector(
            //             onTap: (() {
            //               // Navigator.of(context).pushNamed('/download-screen');
            //             }),
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(8),
            //               child: CachedNetworkImage(
            //                 imageUrl: snapshot.data!.docs[index]['Image'],
            //                 placeholder: (context, url) => Container(
            //                   color: const Color(0xfff5f8fd),
            //                 ),
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     } else {
            //       return const Center(
            //         child: Text(
            //           'There is no tasks',
            //           style: TextStyle(
            //             fontSize: 20,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            // ),
            // // Container(
            // //   height: 200,
            // //   child: const PrefetchImageDemo(),
            // // ),
          ],
        ),
      ),
    );
  }
}

// class PrefetchImageDemo extends StatefulWidget {
//   const PrefetchImageDemo({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _PrefetchImageDemoState();
//   }
// }

// class _PrefetchImageDemoState extends State<PrefetchImageDemo> {
//   final List<String> images = [
//     'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
//     'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
//     'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
//     'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
//     'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
//     'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
//     'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
//   ];

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       for (var imageUrl in images) {
//         precacheImage(NetworkImage(imageUrl), context);
//       }
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       itemCount: images.length,
//       options: CarouselOptions(
//         height: 1000,
//         autoPlay: false,
//         aspectRatio: 1.0,
//         enlargeCenterPage: true,
//       ),
//       itemBuilder: (context, index, realIdx) {
//         return SizedBox(
//           child: Center(
//             child: Image.network(
//               images[index],
//               fit: BoxFit.cover,
//               width: 1000,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
