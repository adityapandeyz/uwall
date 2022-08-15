import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:parallax_animation/parallax_animation.dart';
import 'package:uwall/screens/download_screen.dart';

class PhotoItem {
  final String image;
  final String title;
  final String val;
  PhotoItem(
    this.image,
    this.title,
    this.val,
  );
}

class CategoryScreen extends StatefulWidget {
  static const String routeName = '/category-screen';

  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

final List<PhotoItem> _items = [
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Anime",
    "anime",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Anime",
    "anime",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Anime",
    "anime",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Anime",
    "anime",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Anime",
    "anime",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Anime",
    "anime",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1772973/pexels-photo-1772973.png?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://images.pexels.com/photos/1758531/pexels-photo-1758531.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
    "Anime",
    "anime",
  ),
];

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
      ),
      body: ParallaxArea(
        child: ListView.builder(
          //shrinkWrap: true,
          itemCount: _items.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryView(
                      heading: _items[index].title,
                      value: _items[index].val,
                    ),
                  ),
                );
              }),
              child: ParallaxWidget(
                overflowWidthFactor: 1,
                overflowHeightFactor: 3,
                background: CachedNetworkImage(
                  imageUrl: _items[index].image,
                  placeholder: (context, url) => Container(
                    color: const Color(0xfff5f8fd),
                  ),
                  fit: BoxFit.cover,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: Text(
                      _items[index].title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // Container(
      //   padding: const EdgeInsets.all(15),
      //   child: ListView.builder(
      //     shrinkWrap: true,
      //     physics: const NeverScrollableScrollPhysics(),
      //     itemCount: _items.length,
      //     itemBuilder: (context, index) {
      //       return GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CategoryView(
      //                 heading: _items[index].title,
      //                 value: _items[index].val,
      //               ),
      //             ),
      //           );
      //         },
      //         child: Stack(
      //           alignment: AlignmentDirectional.center,
      //           children: [
      //             // Container(
      //             //   height: MediaQuery.of(context).size.height / 5,
      //             //   width: double.infinity,
      //             //   decoration: BoxDecoration(
      //             //     borderRadius: BorderRadius.circular(12),
      //             //     image: const DecorationImage(
      //             //       fit: BoxFit.cover,
      //             //       image: NetworkImage(
      //             //           'https://cdn.dnaindia.com/sites/default/files/styles/full/public/2021/01/14/949612-first-slide.jpg'),
      //             //     ),
      //             //   ),
      //             // ).asGlass(
      //             //   tintColor: Color.fromARGB(232, 124, 185, 11),
      //             //   clipBorderRadius: BorderRadius.circular(15.0),
      //             // ),
      //             // GlassImage(
      //             //   height: MediaQuery.of(context).size.height / 7,
      //             //   width: double.infinity,
      //             //   blur: 4,
      //             //   image: Image.network(
      //             //     _items[index].image,
      //             //     fit: BoxFit.cover,
      //             //   ),
      //             //   overlayColor: Colors.white.withOpacity(0.1),
      //             //   gradient: LinearGradient(
      //             //     begin: Alignment.topLeft,
      //             //     end: Alignment.bottomRight,
      //             //     colors: [
      //             //       Colors.white.withOpacity(0.2),
      //             //       Colors.blue.withOpacity(0.3),
      //             //     ],
      //             //   ),
      //             //   border: const Border.fromBorderSide(BorderSide.none),
      //             //   shadowStrength: 5,
      //             //   borderRadius: BorderRadius.circular(12),
      //             //   shadowColor: Colors.white.withOpacity(0.24),
      //             // ),

      //             Padding(
      //               padding: const EdgeInsets.only(bottom: 8.0),
      //               child: Container(
      //                 width: double.infinity,
      //                 height: MediaQuery.of(context).size.height / 5,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(12),
      //                   child: CachedNetworkImage(
      //                     imageUrl: _items[index].image,
      //                     placeholder: (context, url) => Container(
      //                       color: const Color(0xfff5f8fd),
      //                     ),
      //                     fit: BoxFit.cover,
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             Text(
      //               _items[index].title,
      //               style: const TextStyle(
      //                 fontSize: 30,
      //                 fontWeight: FontWeight.bold,
      //                 shadows: <Shadow>[
      //                   Shadow(
      //                     offset: Offset(0.4, 0.8),
      //                     blurRadius: 3.0,
      //                     color: Color.fromARGB(255, 104, 104, 104),
      //                   ),
      //                 ],
      //               ),
      //               // style: GoogleFonts.workSans(
      //               //   //color: Colors.white,
      //               //   fontSize: 30,
      //               //   fontWeight: FontWeight.bold,
      //               //   // shadows: <Shadow>[
      //               //   //   const Shadow(
      //               //   //     offset: Offset(0.1, 0.1),
      //               //   //     blurRadius: 1.0,
      //               //   //     color: Color.fromARGB(255, 46, 46, 46),
      //               //   //   ),
      //               //   // ],
      //               // ),
      //             )
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}

class CategoryView extends StatelessWidget {
  final String heading;
  final String value;

  const CategoryView({
    Key? key,
    required this.heading,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(heading),
      ),
      body: Column(
        children: [
          Container(
            width: 50,
            decoration: BoxDecoration(),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('wallpaper')
                .where("Category", isEqualTo: value.toString())
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
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 3,
                    mainAxisExtent: 150,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DownloadScreen(
                                clickedImageId: snapshot.data!.docs[index]
                                    ['createdAt']),
                          ),
                        );
                      }),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data!.docs[index]['Image'],
                          placeholder: (context, url) => Container(
                            color: const Color(0xfff5f8fd),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
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

              return const Center(
                child: Text(
                  'Something went wrong!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
