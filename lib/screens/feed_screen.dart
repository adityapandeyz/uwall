import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwall/widgets/thumbnail_widget.dart';
import '../screens/download_screen.dart';
import '../screens/search_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 8.0, top: 8, bottom: 8, right: 0),
            child: GestureDetector(
              // onTap: () => Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (_) => const AboutAppScreen(),
              //   ),
              // ),
              child: const CircleAvatar(
                radius: 13,
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage: AssetImage(
                    'assets/logo/ic_launcher/play_store_512.png',
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
            InkWell(
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.search_rounded,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FutureBuilder<QuerySnapshot>(
                //   future: FirebaseFirestore.instance
                //       .collection('wallpapers')
                //       .limit(1)
                //       .get(),
                //   builder: (context, AsyncSnapshot snapshot) {
                //     if (snapshot.hasData) {
                //       return ListView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         shrinkWrap: true,
                //         itemCount: snapshot.data!.docs.length,
                //         itemBuilder: (context, index) {
                //           return Padding(
                //             padding: const EdgeInsets.only(
                //               top: 8,
                //             ),
                //             //   child: ImageSlideshow(
                //             //     width: double.infinity,
                //             //     height: 200,
                //             //     initialPage: 0,
                //             //     indicatorColor: Colors.blue,
                //             //     indicatorBackgroundColor: Colors.grey,
                //             //     onPageChanged: (value) {
                //             //       print('Page changed: $value');
                //             //     },
                //             //     autoPlayInterval: 3000,
                //             //     isLoop: true,
                //             //     children: [
                //             //       Image.asset(
                //             //         snapshot.data!.docs[index]['image'],
                //             //         fit: BoxFit.cover,
                //             //       ),
                //             //     ],
                //             //   ),
                //             // );

                //             child: CustomRectangle(
                //               leadingIcon: false,
                //               ontap: () => Navigator.of(context).push(
                //                 MaterialPageRoute(
                //                   builder: (_) => CategoryView(
                //                     heading: snapshot.data!.docs[index]['category']
                //                         .toString(),
                //                     value: snapshot.data!.docs[index]['category']
                //                         .toString()
                //                         .toLowerCase(),
                //                   ),
                //                 ),
                //               ),
                //               child: Container(
                //                 child: Row(
                //                   children: [
                //                     Text(
                //                       snapshot.data!.docs[index]['category'],
                //                       style: const TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           );
                //         },
                //       );
                //     }

                //     return const Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   },
                // ),
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
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      //padding: const EdgeInsets.all(8),
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
                        if (snapshot.data!.docs.length != null) {
                          return ThubmnailWidget(
                            image: snapshot.data!.docs[index]['image'],
                            title: snapshot.data!.docs[index]['title'],
                            downloads: snapshot.data!.docs[index]['downloads'],
                            onTap: () {
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
                            },
                          );
                          // return GestureDetector(
                          //   onTap: (() {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (_) => DownloadScreen(
                          //           wallpaperId: snapshot.data!.docs[index]
                          //               ['wallpaperId'],
                          //           downloads: snapshot.data!.docs[index]
                          //               ['downloads'],
                          //         ),
                          //       ),
                          //     );
                          //   }),
                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(8),
                          //   child: CachedNetworkImage(
                          //     imageUrl: snapshot.data!.docs[index]['image'],
                          //     placeholder: (context, url) =>
                          //         Container(color: secondaryColor),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          // child: ThubmnailWidget(
                          //   image: snapshot.data!.docs[index]['image'],
                          //   title: snapshot.data!.docs[index]['title'],
                          //   downloads: snapshot.data!.docs[index]['downloads'],
                          // ),
                          //);
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
        // body: const TabBarView(
        //   children: [
        //     PopularScreen(),
        //     FollowedScreen(),
        //   ],
        // ),
        );
  }
}

// class PopularScreen extends StatelessWidget {
//   const PopularScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
