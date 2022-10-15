import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomRectangle extends StatelessWidget {
  final double height;
  final bool leadingIcon;
  final IconData icon;
  final Widget child;
  final VoidCallback ontap;
  final bool forward_icon;
  final bool opensOutsideApp;
  final bool isCenter;
  const CustomRectangle({
    Key? key,
    this.height = 50.0,
    this.icon = Icons.abc,
    required this.child,
    required this.ontap,
    this.forward_icon = true,
    this.leadingIcon = true,
    this.opensOutsideApp = false,
    this.isCenter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: isCenter ? Alignment.center : Alignment.centerLeft,
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              leadingIcon ? Icon(icon) : Container(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: child,
              ),
              Container(
                child: forward_icon
                    ? opensOutsideApp
                        ? const Icon(
                            Icons.open_in_browser_rounded,
                            size: 20,
                          )
                        : const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
