import 'package:flutter/material.dart';
import 'package:scale_button/scale_button.dart';

class SquareBox extends StatelessWidget {
  final double height;
  final double width;
  final Color bColor;
  final Color color;
  final String title;
  final String subtitle;
  final bool isIcon;
  final double iconSize;
  final IconData icon;
  final VoidCallback onTap;
  const SquareBox({
    Key? key,
    required this.height,
    required this.width,
    this.color = Colors.white,
    required this.bColor,
    this.title = 'title',
    required this.subtitle,
    this.isIcon = false,
    this.icon = Icons.abc,
    this.iconSize = 50,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      bound: 0.05,
      duration: const Duration(milliseconds: 170),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: bColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isIcon
                  ? Icon(
                      icon,
                      size: iconSize,
                      color: color,
                    )
                  : Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(
                height: 4,
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
