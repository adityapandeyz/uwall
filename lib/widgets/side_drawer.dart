import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:uwall/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        } else if (snapshot.hasData) {
          return const LogedInDrawer();
        } else {
          return const LogedOutDrawer();
        }
      },
    );
  }
}

class LogedInDrawer extends StatefulWidget {
  const LogedInDrawer({Key? key}) : super(key: key);

  @override
  State<LogedInDrawer> createState() => _LogedInDrawerState();
}

class _LogedInDrawerState extends State<LogedInDrawer> {
  String? name = "";
  String? email = "";
  String? image = "";

  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then(
      (snapshot) async {
        if (snapshot.exists) {
          setState(
            () {
              name = snapshot.data()!['name'];
              email = snapshot.data()!['email'];
              image = snapshot.data()!['userImage'];
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    _getDataFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: secondaryColor,
      child: Column(
        children: <Widget>[
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Color.fromARGB(255, 104, 104, 104),
          //   ),
          //   padding: EdgeInsets.all(20),
          //   margin: EdgeInsets.all(1),
          //   child: Center(
          //     child: Text(
          //       'uwall',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(color: Colors.white, fontSize: 25),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 30,
          ),
          image != null
              ? CircleAvatar(
                  radius: 20,
                  // child: CachedNetworkImage(
                  //   imageUrl: image!,
                  //   placeholder: (context, url) => Container(
                  //     color: const Color(0xfff5f8fd),
                  //   ),
                  //   fit: BoxFit.cover,
                  // ),

                  backgroundImage: NetworkImage(image!),
                )
              : const CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 105, 105, 105),
                  radius: 20,
                  child: Icon(
                    Icons.account_circle_rounded,
                    size: 40,
                  ),
                ),

          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            title: Text(
              name!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            onTap: () => {},
          ),

          const Divider(color: Colors.grey),

          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            // leading: Icon(Icons.upload_rounded),
            title: GradientText(
              'Upload',
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              colors: const [
                Color.fromARGB(255, 121, 73, 255),
                Color.fromARGB(255, 255, 69, 69),
                Color.fromARGB(255, 214, 9, 9),
              ],
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/upload-screen'),
            },
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(
              Icons.search_rounded,
              size: 20,
            ),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Search',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.category_outlined,
              size: 20,
            ),
            title: const Text(
              'Category',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/category-screen'),
            },
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.save_alt_rounded,
              size: 20,
            ),
            title: const Text(
              'Saved',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),

          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.feedback_outlined,
              size: 20,
            ),
            title: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.info_outline_rounded,
              size: 20,
            ),
            title: const Text(
              'About App',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.logout_rounded,
              size: 20,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {
              FirebaseAuth.instance.signOut().then(
                (res) {
                  Navigator.of(context).pop();
                },
              ),
            },
          ),
          const SizedBox(height: 40),

          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(134, 255, 255, 255),
              ),
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/privacy-policy-screen'),
            },
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            title: const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(134, 255, 255, 255),
              ),
            ),
            onTap: () => {
              Navigator.of(context).pop(),
            },
          ),
          const Spacer(
            flex: 2,
          ),
          const Text(
            'uwall',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

class LogedOutDrawer extends StatelessWidget {
  const LogedOutDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: secondaryColor,
      child: Column(
        children: <Widget>[
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //     color: Color.fromARGB(255, 104, 104, 104),
          //   ),
          //   padding: EdgeInsets.all(20),
          //   margin: EdgeInsets.all(1),
          //   child: Center(
          //     child: Text(
          //       'uwall',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(color: Colors.white, fontSize: 25),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 30,
          ),
          ListTile(
            //leading: Icon(Icons.login_rounded),
            title: GradientText(
              'Sign In',
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              colors: const [
                Color.fromARGB(255, 121, 73, 255),
                Color.fromARGB(255, 255, 69, 69),
                Color.fromARGB(255, 214, 9, 9),
              ],
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/signin-screen'),
            },
          ),
          const Divider(color: Colors.grey),

          ListTile(
            leading: const Icon(
              Icons.search_rounded,
              size: 20,
            ),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Search',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.category_outlined,
              size: 20,
            ),
            title: const Text(
              'Category',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/category-screen'),
            },
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.save_alt_rounded,
              size: 20,
            ),
            title: const Text(
              'Saved',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),

          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.feedback_outlined,
              size: 20,
            ),
            title: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            leading: const Icon(
              Icons.info_outline_rounded,
              size: 20,
            ),
            title: const Text(
              'About App',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),

          const SizedBox(height: 40),

          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(134, 255, 255, 255),
              ),
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/privacy-policy-screen'),
            },
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 1.0,
            title: const Text(
              'Terms of Use',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(134, 255, 255, 255),
              ),
            ),
            onTap: () => {
              Navigator.of(context).pop(),
            },
          ),
          const Spacer(
            flex: 2,
          ),
          const Text(
            'uwall',
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),

          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
