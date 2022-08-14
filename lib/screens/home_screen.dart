import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwall/screens/download_screen.dart';
import 'package:uwall/widgets/side_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      appBar: AppBar(
        title: const Text('uwall'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('wallpaper')
                  // .where("Category", isEqualTo: value.toString())
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 3,
                      mainAxisExtent: 150,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (() {
                          Navigator.of(context).pushNamed('/download-screen');
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
      ),
    );
  }
}
