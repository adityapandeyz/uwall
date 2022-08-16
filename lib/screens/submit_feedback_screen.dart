import 'package:flutter/material.dart';
import 'package:uwall/widgets/custom_square_button.dart';

class SubmitFeedbackScreen extends StatelessWidget {
  static const String routeName = '/submit-feedback-screen';

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
            CustomSquareButton(
              icon: Icons.feedback_outlined,
              title: 'submit Feedback',
              subTitle: 'email',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            CustomSquareButton(
              icon: Icons.play_arrow,
              title: 'Review on Google Play',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
