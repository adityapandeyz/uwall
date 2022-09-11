import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uwall/widgets/custom_rectangle.dart';
import 'package:uwall/widgets/custom_square_button.dart';

final Uri _googlePlayServicesUrl =
    Uri.parse('https://www.google.com/policies/privacy/');

class SubmitFeedbackScreen extends StatelessWidget {
  const SubmitFeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRectangle(
              height: 100,
              icon: Icons.email_outlined,
              opensOutsideApp: true,
              child: const Text(
                'Write an email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ontap: () => _launchEmail(),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomRectangle(
              height: 100,
              icon: Icons.play_arrow_rounded,
              opensOutsideApp: true,
              child: const Text(
                'Review on Google Play',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ontap: () {},
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

_launchEmail() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'admin@dresolution.tech',
    query:
        'subject=App Feedback&body=App Version 0.1.0+1', //add subject and body here
  );
  var url = params.toString();

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> _launchGooglePlayServices() async {
  if (!await launchUrl(_googlePlayServicesUrl)) {
    throw 'Could not launch $_googlePlayServicesUrl';
  }
}
