import 'package:flutter/material.dart';
import 'package:scale_button/scale_button.dart';

import '../screens/profile_screen.dart';

class UserTile extends StatelessWidget {
  final String photoUrl;
  final String name;
  // final String postCount;
  final String userId;
  const UserTile(
      {super.key,
      required this.photoUrl,
      required this.name,
      // required this.postCount,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      bound: 0.05,
      duration: const Duration(milliseconds: 170),
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              userId: userId,
            ),
          ),
        );
      }),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundImage: Image.network(
            photoUrl,
          ).image,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        // subtitle: const Text(
        //   '12 posts',
        //   style: TextStyle(
        //     color: lightGreyText,
        //     fontWeight: FontWeight.w600,
        //     fontSize: 14,
        //   ),
        // ),
        // trailing: const Icon(Icons.food_bank),
      ),
    );
  }
}
