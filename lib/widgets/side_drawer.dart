import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

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
            title: GradientText(
              'Upload',
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              colors: const [
                Color.fromARGB(255, 57, 14, 177),
                Color.fromARGB(255, 214, 9, 9),
                Color.fromARGB(255, 214, 9, 9),
              ],
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/upload-screen'),
            },
          ),
          ListTile(
            title: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            title: const Text(
              'About App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
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
            title: GradientText(
              'Sign In',
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              colors: const [
                Color.fromARGB(255, 57, 14, 177),
                Color.fromARGB(255, 214, 9, 9),
                Color.fromARGB(255, 214, 9, 9),
              ],
            ),
            onTap: () => {
              Navigator.of(context).pushNamed('/auth-screen'),
            },
          ),
          ListTile(
            title: const Text(
              'Submit Feedback',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            title: const Text(
              'About App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
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
