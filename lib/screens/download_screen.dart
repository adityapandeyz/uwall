import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uwall/widgets/thumbnail_widget.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/liked_screen.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/custom_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../widgets/custom_rectangle.dart';

import '../auth/signin_screen.dart';
import '../widgets/popover.dart';

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
  bool showDeleteButton = false;

  final _controller = CropController();

  _askPermission() async {
    /*await PermissionHandler()
        .checkPermissionStatus(Permission.storage);*/
    Permission.storage;
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

  @override
  void initState() {
    super.initState();
    checkUserLoginState();
    getPostData();
  }

  getPostData() async {
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

      if (postSnap2.data()!['uid'] == FirebaseAuth.instance.currentUser!.uid ||
          FirebaseAuth.instance.currentUser!.uid ==
              'bZW5S6L7Wdf2AI6I5YoXsFP8qY32') {
        setState(() {
          showDeleteButton = true;
        });
      }

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
                              child: Center(child: CircularProgressIndicator()),
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
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,

                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            // height: 200,
                                            width: 200,
                                            child: Text(
                                              snapshot.data!
                                                  .docs[index]['description']
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    87, 255, 255, 255),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              showDeleteButton
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Color.fromARGB(
                                                  255, 26, 26, 26),
                                              title: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Text("Are you sure?"),
                                                  Text(
                                                    "This step will permanently delete this Image!",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CustomButton(
                                                        text: 'Delete',
                                                        onTap: () async {
                                                          try {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'wallpapers')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'wallpaperId']
                                                                    .toString())
                                                                .delete();

                                                            showSnackBar(
                                                                context,
                                                                'Wallpaper deleted successfully!');

                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder: (_) => ProfileScreen(
                                                                    userId: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'uid']
                                                                        .toString()),
                                                              ),
                                                            );
                                                          } catch (err) {
                                                            showSnackBar(
                                                              context,
                                                              err.toString(),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      TextButton(
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.delete),
                                    )
                                  : Container(),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: isLiked
                                          ? CustomRectangle(
                                              forwardIcon: false,
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
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['wallpaperId'])
                                                      .update({
                                                    'likes':
                                                        FieldValue.arrayRemove([
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                    ]),
                                                  }).then(
                                                    (value) {
                                                      Navigator.canPop(context)
                                                          ? Navigator.pop(
                                                              context)
                                                          : null;

                                                      showSnackBar(context,
                                                          'You unliked this wallpaper!');

                                                      Navigator.of(context)
                                                          .push(
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

                                                  showSnackBar(context,
                                                      error.toString());
                                                }
                                              },
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: const [
                                                    Icon(Icons
                                                        .thumb_up_alt_rounded),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'Liked',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              forwardIcon: false,
                                              leadingIcon: false,
                                              isCenter: true,
                                              child: Row(
                                                children: const [
                                                  Icon(Icons
                                                      .thumb_up_alt_outlined),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Like',
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
                                                    barrierDismissible: false,
                                                    builder: (context) =>
                                                        const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  );

                                                  FirebaseFirestore.instance
                                                      .collection('wallpapers')
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['wallpaperId'])
                                                      .update({
                                                    'likes':
                                                        FieldValue.arrayUnion([
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                    ]),
                                                  }).then(
                                                    (value) {
                                                      Navigator.canPop(context)
                                                          ? Navigator.pop(
                                                              context)
                                                          : null;

                                                      showSnackBar(context,
                                                          'You liked this wallpaper!');

                                                      Navigator.of(context)
                                                          .push(
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

                                                  showSnackBar(context,
                                                      error.toString());
                                                }
                                              },
                                            ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomButton(
                                        text: 'Download',
                                        onTap: () async {
                                          showModalBottomSheet<int>(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (context) {
                                              return Popover(
                                                child: Column(
                                                  children: [
                                                    buildListItem(
                                                      context,
                                                      title: 'Save to gallery',
                                                      leading: Icons
                                                          .download_done_rounded,
                                                      onpressed: () async {
                                                        try {
                                                          await _askPermission();
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

                                                          var response =
                                                              await Dio().get(
                                                            snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['image']
                                                                .toString(),
                                                            options: Options(
                                                              responseType:
                                                                  ResponseType
                                                                      .bytes,
                                                            ),
                                                          );
                                                          await ImageGallerySaver
                                                              .saveImage(
                                                            Uint8List.fromList(
                                                                response.data),
                                                          );

                                                          showSnackBar(context,
                                                              'Image saved to gallery!');

                                                          total = widget
                                                                  .downloads! +
                                                              1;

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'wallpapers')
                                                              .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'wallpaperId'])
                                                              .update({
                                                            'downloads': total,
                                                          }).then((value) {
                                                            Navigator.canPop(
                                                                    context)
                                                                ? Navigator.pop(
                                                                    context)
                                                                : null;
                                                          });
                                                        } on PlatformException catch (error) {
                                                          Navigator.pop(
                                                              context);

                                                          showSnackBar(context,
                                                              error.toString());
                                                        }
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    buildListItem(
                                                      context,
                                                      title:
                                                          'Set as Home screen',
                                                      leading: Icons
                                                          .add_to_home_screen_rounded,
                                                      isActive: false,
                                                      onpressed: () async {
                                                        try {
                                                          await _askPermission();

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

                                                          String url =
                                                              '${snapshot.data!.docs[index]['image']}';
                                                          var cachedimage =
                                                              await DefaultCacheManager()
                                                                  .getSingleFile(
                                                                      url); //image file

                                                          Uint8List uint8list =
                                                              Uint8List.fromList(File(
                                                                      cachedimage
                                                                          .path)
                                                                  .readAsBytesSync());

                                                          Crop(
                                                            image: uint8list,
                                                            aspectRatio: 4 / 3,
                                                            initialAreaBuilder:
                                                                (rect) => Rect.fromLTRB(
                                                                    rect.left +
                                                                        24,
                                                                    rect.top +
                                                                        32,
                                                                    rect.right -
                                                                        24,
                                                                    rect.bottom -
                                                                        32),
                                                            baseColor: Colors
                                                                .blue.shade900,
                                                            maskColor: Colors
                                                                .white
                                                                .withAlpha(100),
                                                            radius: 20,
                                                            cornerDotBuilder: (size,
                                                                    edgeAlignment) =>
                                                                const DotControl(
                                                                    color: Colors
                                                                        .blue),
                                                            interactive: true,
                                                            fixArea: true,
                                                            controller:
                                                                _controller,
                                                            onCropped: (image) {
                                                              int location =
                                                                  WallpaperManagerFlutter
                                                                      .HOME_SCREEN;
                                                              WallpaperManagerFlutter()
                                                                  .setwallpaperfromFile(
                                                                      image,
                                                                      location);
                                                            },
                                                          );

                                                          //Choose screen type

                                                          showSnackBar(context,
                                                              'Set as Home Screen');

                                                          total = widget
                                                                  .downloads! +
                                                              1;

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'wallpapers')
                                                              .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'wallpaperId'])
                                                              .update({
                                                            'downloads': total,
                                                          }).then((value) {
                                                            Navigator.canPop(
                                                                    context)
                                                                ? Navigator.pop(
                                                                    context)
                                                                : null;
                                                          });
                                                        } catch (error) {
                                                          showSnackBar(context,
                                                              error.toString());
                                                        }
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    buildListItem(
                                                      context,
                                                      title:
                                                          'Set as Lock screen',
                                                      leading: Icons
                                                          .screen_lock_portrait_rounded,
                                                      onpressed: () {},
                                                      isActive: false,
                                                    ),
                                                    buildListItem(
                                                      context,
                                                      title: 'Set both',
                                                      leading:
                                                          Icons.check_circle,
                                                      onpressed: () {},
                                                      isActive: false,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
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
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    );
                  },
                );
              },
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
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    crossAxisCount: 2,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                    if (snapshot.data!.docs.length != null) {
                      return ThubmnailWidget(
                        image: snapshot.data!.docs[index]['image'],
                        title: snapshot.data!.docs[index]['title'],
                        downloads: snapshot.data!.docs[index]['downloads'],
                        onTap: () {
                          Navigator.pushReplacement(
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
                        },
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
