import 'package:flutter/material.dart';
import '../utils/colors.dart';

class EmptyWarning extends StatelessWidget {
  final String text;
  final IconData icon;
  const EmptyWarning({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: lightGreyText,
          ),
          Text(
            text,
            style: const TextStyle(
              color: lightGreyText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
