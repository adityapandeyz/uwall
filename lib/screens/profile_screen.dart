import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'download_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile-screen';

  final String userId;

  const ProfileScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name = "";
  String? email = "";
  String? id;
  String? image = "";

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get()
        .then(
      (snapshot) async {
        if (snapshot.exists) {
          setState(
            () {
              name = snapshot.data()!['name'];
              email = snapshot.data()!['email'];
              id = snapshot.data()!['id'];
              image = snapshot.data()!['userImage'].toString();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(image!),
                ),
                const SizedBox(height: 30),
                Text(
                  name!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  email!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('wallpaper')
                      .where("id", isEqualTo: id)
                      // .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      if (snapshot.hasData) {
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
                            if (snapshot.data!.docs.length != null) {
                              return GestureDetector(
                                onTap: (() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DownloadScreen(
                                        clickedImageId: snapshot
                                            .data!.docs[index]['createdAt'],
                                        downloads: snapshot.data!.docs[index]
                                            ['downloads'],
                                      ),
                                    ),
                                  );
                                }),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    snapshot.data!.docs[index]['Image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                            return const Center(
                              child: Text(
                                'No Posts.',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(
                        child: Text(
                          'No Posts.',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'No Internet!',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
