import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Powered by Flutter',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),

                  //textAlign: TextAlign.,
                ),
                const SizedBox(height: 10),
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage(
                    'assets/logo/ic_launcher/play_store_512.png',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Version: 0.3.5+8',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  //textAlign: TextAlign.,
                ),
                // const Text(
                //   'BETA Release',
                //   style: TextStyle(
                //     fontWeight: FontWeight.w500,
                //     fontSize: 11,
                //   ),
                //   //textAlign: TextAlign.,
                // ),
                const SizedBox(height: 10),
                const Text(
                  ' Developers:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
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
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/logo/dot.-150x150.png',
                        ),
                      )),
                ),
                const SizedBox(height: 10),
                const Text(
                  '© 2022 dotResolution Studio',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
