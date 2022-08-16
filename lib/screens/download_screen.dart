import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DownloadScreen extends StatelessWidget {
  final Timestamp clickedImageId;
  static const String routeName = '/download-screen';

  const DownloadScreen({
    Key? key,
    required this.clickedImageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('wallpaper')
                .where("createdAt", isEqualTo: clickedImageId)
                // .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return CarouselSlider.builder(
                  itemCount: snapshot.data!.docs.length,
                  options: CarouselOptions(
                    // height: 1000,
                    height: 600,
                    aspectRatio: 16 / 9,

                    autoPlay: false,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return SizedBox(
                      child: Center(
                        child: Image.network(
                          snapshot.data!.docs[index]['Image'],
                          fit: BoxFit.cover,
                          width: 1000,
                        ),
                      ),
                    );
                  },
                );
                // return GridView.builder(
                //   physics: const NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   itemCount: snapshot.data!.docs.length,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisSpacing: 5,
                //     mainAxisSpacing: 5,
                //     crossAxisCount: 3,
                //     mainAxisExtent: 150,
                //   ),
                //   itemBuilder: (BuildContext context, int index) {
                //     return GestureDetector(
                //       onTap: (() {
                //         // Navigator.of(context).pushNamed('/download-screen');
                //       }),
                //       child: ClipRRect(
                //         borderRadius: BorderRadius.circular(8),
                //         child: CachedNetworkImage(
                //           imageUrl: snapshot.data!.docs[index]['Image'],
                //           placeholder: (context, url) => Container(
                //             color: const Color(0xfff5f8fd),
                //           ),
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     );
                //   },
                // );
              } else {
                return const Center(
                  child: Text(
                    'There is no tasks',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              }
            },
          ),
          // Container(
          //   height: 200,
          //   child: const PrefetchImageDemo(),
          // ),
        ],
      ),
    );
  }
}

class PrefetchImageDemo extends StatefulWidget {
  const PrefetchImageDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PrefetchImageDemoState();
  }
}

class _PrefetchImageDemoState extends State<PrefetchImageDemo> {
  final List<String> images = [
    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
    'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
    'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var imageUrl in images) {
        precacheImage(NetworkImage(imageUrl), context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        height: 1000,
        autoPlay: false,
        aspectRatio: 1.0,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, realIdx) {
        return SizedBox(
          child: Center(
            child: Image.network(
              images[index],
              fit: BoxFit.cover,
              width: 1000,
            ),
          ),
        );
      },
    );
  }
}
