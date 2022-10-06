import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uwall/widgets/custom_rectangle.dart';
import 'package:uwall/widgets/custom_square_button.dart';

final Uri _googlePlayUrl = Uri.parse(
    'https://play.google.com/store/apps/details?id=tech.dresolution.uwall');

class SubmitFeedbackScreen extends StatefulWidget {
  const SubmitFeedbackScreen({Key? key}) : super(key: key);

  @override
  State<SubmitFeedbackScreen> createState() => _SubmitFeedbackScreenState();
}

class _SubmitFeedbackScreenState extends State<SubmitFeedbackScreen> {
  Future<void>? _launched;
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

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
              ontap: () => setState(() {
                _launched = _launchInBrowser(_googlePlayUrl);
              }),
              child: Text(
                'Review on Google Play',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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
        'subject=App Feedback&body=App Version 0.3.1+4', //add subject and body here
  );
  var url = params.toString();

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// Future<void> _launchGooglePlay() async {
//   if (!await launchUrl(_googlePlayUrl)) {
//     throw 'Could not launch $_googlePlayUrl';
//   }
// }
