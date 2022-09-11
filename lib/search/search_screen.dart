import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwall/screens/category_screen.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:uwall/models/user.dart';
import 'package:uwall/screens/profile_screen.dart';
import 'package:uwall/widgets/custom_rectangle.dart';

import '../screens/download_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowResult = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Form(
          child: TextFormField(
            controller: searchController,
            onChanged: (textEntered) {
              setState(
                () {
                  isShowResult = true;
                },
              );
              // initSearchingPost(textEntered);
            },
            decoration: InputDecoration(
              filled: true,
              //fillColor: secondaryColor,
              contentPadding:
                  const EdgeInsets.only(left: 18.0, bottom: 10.0, top: 13.0),

              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12.0),
              // ),
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(12.0),
              // ),

              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Search...',
              hintStyle: const TextStyle(
                color: Colors.white54,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  isShowResult = true;
                },
              ),
              prefixIcon: IconButton(
                icon: const Padding(
                  padding: EdgeInsets.only(right: 12.0, bottom: 4.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      body: isShowResult
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Users

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Users',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where(
                            'fullName',
                            isGreaterThanOrEqualTo: searchController.text,
                          )
                          .limit(2)
                          .get(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              // return InkWell(
                              //   onTap: () => Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //       builder: (_) => ProfileScreen(
                              //         userId: snapshot.data!.docs[index]['uid'],
                              //       ),
                              //     ),
                              //   ),

                              //   child: ListTile(
                              //     leading: CircleAvatar(
                              //       backgroundImage: NetworkImage(
                              //         snapshot.data!.docs[index]['photoUrl'],
                              //       ),
                              //     ),
                              //     title: Text(
                              //       snapshot.data!.docs[index]['fullName'],
                              //     ),
                              //   ),

                              // );
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: CustomRectangle(
                                  leadingIcon: false,
                                  ontap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ProfileScreen(
                                        userId: snapshot.data!.docs[index]
                                            ['uid'],
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            snapshot.data!.docs[index]
                                                ['photoUrl'],
                                          ),
                                          radius: 26,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['fullName'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        // return const Center(
                        //   child: CircularProgressIndicator(),
                        // );
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),

                    // Category

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('wallpapers')
                          .where(
                            'category',
                            isGreaterThanOrEqualTo: searchController.text,
                          )
                          .limit(1)
                          .get(),
                      builder: (context, AsyncSnapshot snapshot) {
                        const Text(
                          'No data...',
                          style: TextStyle(
                            color: Color.fromARGB(255, 102, 102, 102),
                          ),
                        );
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              // return InkWell(
                              //   onTap: () => Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //       builder: (_) => ProfileScreen(
                              //         userId: snapshot.data!.docs[index]['uid'],
                              //       ),
                              //     ),
                              //   ),

                              //   child: ListTile(
                              //     leading: CircleAvatar(
                              //       backgroundImage: NetworkImage(
                              //         snapshot.data!.docs[index]['photoUrl'],
                              //       ),
                              //     ),
                              //     title: Text(
                              //       snapshot.data!.docs[index]['fullName'],
                              //     ),
                              //   ),

                              // );
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: CustomRectangle(
                                  leadingIcon: false,
                                  ontap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CategoryView(
                                        heading: snapshot
                                            .data!.docs[index]['category']
                                            .toString(),
                                        value: snapshot
                                            .data!.docs[index]['category']
                                            .toString()
                                            .toLowerCase(),
                                        // userId: snapshot.data!.docs[index]
                                        //     [''],
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        // CircleAvatar(
                                        //   backgroundImage: NetworkImage(
                                        //     snapshot.data!.docs[index]
                                        //         ['photoUrl'],
                                        //   ),
                                        //   radius: 26,
                                        // ),
                                        Text(
                                          snapshot.data!.docs[index]
                                              ['category'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        // return const Center(
                        //   child: CircularProgressIndicator(),
                        // );
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),

                    // wallpapers

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Wallpapers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('wallpapers')
                          .where(
                            'title',
                            isGreaterThanOrEqualTo: searchController.text,
                          )
                          .limit(3)
                          .get(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
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
                            itemBuilder: (context, index) {
                              // return InkWell(
                              //   onTap: () => Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //       builder: (_) => ProfileScreen(
                              //         userId: snapshot.data!.docs[index]['uid'],
                              //       ),
                              //     ),
                              //   ),

                              //   child: ListTile(
                              //     leading: CircleAvatar(
                              //       backgroundImage: NetworkImage(
                              //         snapshot.data!.docs[index]['photoUrl'],
                              //       ),
                              //     ),
                              //     title: Text(
                              //       snapshot.data!.docs[index]['fullName'],
                              //     ),
                              //   ),

                              // );
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    snapshot.data!.docs[index]['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        // return const Center(
                        //   child: CircularProgressIndicator(),
                        // );

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.search,
                size: 200,
                color: Color.fromARGB(61, 124, 124, 124),
              ),
            ),
    );
  }
}
