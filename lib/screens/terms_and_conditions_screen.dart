import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final Uri _googlePlayServicesUrl =
      Uri.parse('https://www.google.com/policies/privacy/');
  final Uri _googleAnalyticsForFirebaseUrl =
      Uri.parse('https://firebase.google.com/policies/analytics');
  final Uri _firebaseCrashlyticsUrl =
      Uri.parse('https://firebase.google.com/support/privacy/');

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
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Terms & Conditions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                """By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to dotResolution Studio.

dotResolution Studio is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.

The uwall app stores and processes personal data that you have provided to us, to provide our Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the uwall app won’t work properly or at all.

The app does use third-party services that declare their Terms and Conditions.

Link to Terms and Conditions of third-party service providers used by the app""",
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() {
                  _launched = _launchInBrowser(_googlePlayServicesUrl);
                }),
                child: const Text(
                  '\u2022 Google Play Services',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => setState(() {
                  _launched = _launchInBrowser(_googleAnalyticsForFirebaseUrl);
                }),
                child: const Text(
                  '\u2022 Google Analytics for Firebase',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => setState(() {
                  _launched = _launchInBrowser(_firebaseCrashlyticsUrl);
                }),
                child: const Text(
                  '\u2022 Firebase Crashlytics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                  """You should be aware that there are certain things that dotResolution Studio will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but dotResolution Studio cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.

If you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

Along the same lines, dotResolution Studio cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, dotResolution Studio cannot accept responsibility.

With respect to dotResolution Studio’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. dotResolution Studio accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.

At some point, we may wish to update the app. The app is currently available on Android – the requirements for the system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. dotResolution Studio does not promise that it will always update the app so that it is relevant to you and/or works with the Android version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device."""),
              const SizedBox(height: 10),
              const Text(
                'Changes to This Terms and Conditions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                  """We may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Terms and Conditions on this page.

These terms and conditions are effective as of 2022-08-16"""),
              const SizedBox(height: 10),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                  """If you have any questions or suggestions about our Terms and Conditions, do not hesitate to contact us at:"""),
              GestureDetector(
                onTap: () {
                  _launchEmail();
                },
                child: const Text(
                  'admin@dresolution.tech',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

_launchEmail() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'admin@dresolution.tech',
    query: 'body=App Version 0.3.0+3', //add subject and body here
  );
  var url = params.toString();

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// Future<void> _launchGooglePlayServices() async {
//   if (!await launchUrl(_googlePlayServicesUrl)) {
//     throw 'Could not launch $_googlePlayServicesUrl';
//   }
// }

// Future<void> _launchGoogleAnalyticsForFirebaseUrl() async {
//   if (!await launchUrl(_googleAnalyticsForFirebaseUrl)) {
//     throw 'Could not launch $_googleAnalyticsForFirebaseUrl';
//   }
// }

// Future<void> _launchFirebaseCrashlyticsUrl() async {
//   if (!await launchUrl(_firebaseCrashlyticsUrl)) {
//     throw 'Could not launch $_firebaseCrashlyticsUrl';
//   }
// }
