import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  static const String routeName = '/about-app-screen';

  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              ' Developers:',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                //borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 57, 14, 177),
                    Color.fromARGB(255, 214, 9, 9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/logo/dot.-150x150.png'),
              ),
            ),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              //textAlign: TextAlign.,
            ),
            const Text(
              '© 2022 dotResolution Studio',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
