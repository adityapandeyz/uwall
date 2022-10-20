import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:parallax_animation/parallax_animation.dart';
import '../screens/download_screen.dart';
import '../utils/colors.dart';
import '../widgets/empty_warning.dart';
import '../widgets/thumbnail_widget.dart';

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
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

final List<PhotoItem> _items = [
  PhotoItem(
    "https://r4.wallpaperflare.com/wallpaper/996/184/951/night-artwork-futuristic-city-cyberpunk-wallpaper-58e64db860307c78c0cc910e28a2847a.jpg",
    "3D",
    "3d",
  ),
  PhotoItem(
    "https://images.wallpaperscraft.com/image/single/flight_balloon_sky_86980_1280x720.jpg",
    "Abstract",
    "abstract",
  ),
  PhotoItem(
    "https://images.wallpaperscraft.com/image/single/wolf_predator_howl_134450_1280x720.jpg",
    "Animals",
    "animals",
  ),
  PhotoItem(
    "https://r4.wallpaperflare.com/wallpaper/869/512/849/anime-demon-slayer-kimetsu-no-yaiba-zenitsu-agatsuma-hd-wallpaper-f2f12240fdf64e0b1ab802850008e9d2.jpg",
    "Anime",
    "anime",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/133/969/139/artwork-nature-landscape-fantasy-art-wallpaper-preview.jpg",
    "Art",
    "art",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/840/954/346/dark-night-rain-car-wallpaper-preview.jpg",
    "Cars",
    "cars",
  ),
  PhotoItem(
    "https://images.unsplash.com/photo-1444723121867-7a241cacace9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    "City",
    "city",
  ),
  PhotoItem(
    "https://images.wallpaperscraft.com/image/single/monster_silhouette_forest_131112_1280x720.jpg",
    "Dark",
    "dark",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/328/266/395/wlop-artwork-women-digital-art-wallpaper-preview.jpg",
    "Fantasy",
    "fantasy",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/943/63/773/cyberpunk-2077-cyberpunk-video-games-wallpaper-preview.jpg",
    "Games",
    "games",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/221/116/854/joaquin-phoenix-joker-batman-fire-car-hd-wallpaper-preview.jpg",
    "Movies",
    "movies",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/919/575/783/nature-landscape-lake-mountains-wallpaper-preview.jpg",
    "Nature",
    "nature",
  ),
  PhotoItem(
    "https://images.wallpaperscraft.com/image/single/ball_mirror_green_138712_1280x720.jpg",
    "Others",
    "others",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/1023/915/631/nasa-space-suit-digital-art-space-wallpaper-preview.jpg",
    "Space",
    "space",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/16/671/726/lionel-messi-football-barcelona-hd-wallpaper-preview.jpg",
    "Sports",
    "sports",
  ),
  PhotoItem(
    "https://c4.wallpaperflare.com/wallpaper/857/457/204/iron-man-artwork-comic-books-superhero-wallpaper-preview.jpg",
    "Technology",
    "technology",
  ),
  PhotoItem(
    "https://images.wallpaperscraft.com/image/single/wood_surface_texture_wet_119316_1280x720.jpg",
    "Textures",
    "textures",
  ),
  PhotoItem(
    "https://images.wallpaperscraft.com/image/single/astronaut_spacesuit_reflection_144426_1280x720.jpg",
    "Vectors",
    "vectors",
  ),
  PhotoItem(
    "https://images.wallpaperscraft.com/image/single/neon_backlight_inscription_121706_1280x720.jpg",
    "Words",
    "words",
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
                    color: secondaryColor,
                  ),
                  fit: BoxFit.cover,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _items[index].title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded)
                        ],
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wallpapers')
            .where("category", isEqualTo: value.toString())
            // .orderBy('downloads', descending: true)
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
            } else if (snapshot.data.docs.isEmpty) {
              return const EmptyWarning(
                text: 'No Posts!',
                icon: Icons.no_photography_sharp,
              );
            }

            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 3,
                mainAxisExtent: 250,
              ),
              itemBuilder: (BuildContext context, int index) {
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
                          downloads: snapshot.data!.docs[index]['downloads'],
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
                //   child: ThubmnailWidget(
                //     image: snapshot.data!.docs[index]['image'],
                //     title: snapshot.data!.docs[index]['title'],
                //     downloads: snapshot.data!.docs[index]['downloads'],
                //   ),
                //   //  ClipRRect(
                //   //   borderRadius: BorderRadius.circular(8),
                //   //   child: CachedNetworkImage(
                //   //     imageUrl: snapshot.data!.docs[index]['image'],
                //   //     placeholder: (context, url) =>
                //   //         Container(color: secondaryColor),
                //   //     fit: BoxFit.cover,
                //   //   ),
                //   // ),
                // );
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
        },
      ),
    );
  }
}
