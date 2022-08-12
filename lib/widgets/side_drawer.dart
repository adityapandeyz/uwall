import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:uwall/utils/colors.dart';

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

class LogedInDrawer extends StatelessWidget {
  const LogedInDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
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
            title: Text(
              user.email!,
              //style: TextStyle(fontSize: 24),
            ),
            onTap: () => {},
          ),
          ListTile(
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
            leading: const Icon(Icons.search_rounded),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Search',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.category_rounded),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.save_rounded),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Saved',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),

          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            horizontalTitleGap: 1.0,
            title: const Text(
              'About App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20.0,
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
            leading: Icon(Icons.feedback_outlined),
            horizontalTitleGap: 1.0,
            title: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            horizontalTitleGap: 1.0,
            title: const Text(
              'About App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
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
