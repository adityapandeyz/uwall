import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uwall/screens/profile_screen.dart';
import 'package:uwall/widgets/custom_button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DownloadScreen extends StatefulWidget {
  final Timestamp? clickedImageId;
  final int? downloads;

  static const String routeName = '/download-screen';

  const DownloadScreen({
    Key? key,
    required this.clickedImageId,
    required this.downloads,
  }) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  int? total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('wallpaper')
                  .where("createdAt", isEqualTo: widget.clickedImageId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Image.network(
                              snapshot.data!.docs[index]['Image']),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                'uploaded by:',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(129, 184, 184, 184)),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProfileScreen(
                                      userId: snapshot.data!.docs[index]['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(snapshot
                                            .data!.docs[index]['userImage']),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]['userName']
                                              .toString(),
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['email']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        //   child: CustomButton(
                        //     text: 'Set as wallpaper',
                        //     onTap: () {},
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                  snapshot.data!.docs[index]['Image']
                                      .toString(),
                                  options: Options(
                                    responseType: ResponseType.bytes,
                                  ),
                                );
                                await ImageGallerySaver.saveImage(
                                  Uint8List.fromList(response.data),
                                );

                                Fluttertoast.showToast(
                                    msg: 'Image Saved to Gallery');
                                total = widget.downloads! + 1;

                                FirebaseFirestore.instance
                                    .collection('wallpaper')
                                    .doc(snapshot.data!.docs[index].id)
                                    .update({
                                  'downloads': total,
                                }).then((value) {
                                  Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null;

                                  Navigator.of(context)
                                      .pushNamed('/home-screen');
                                });
                              } on PlatformException catch (error) {
                                Navigator.pop(context);

                                Fluttertoast.showToast(msg: error.toString());
                              }
                            },
                          ),
                        )
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
