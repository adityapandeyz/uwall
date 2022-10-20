import 'package:flutter/material.dart';
import 'package:uwall/utils/colors.dart';

class Popover extends StatelessWidget {
  final Widget child;

  const Popover({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Container(
        // margin: const EdgeInsets.all(16.0),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildHandle(context), if (child != null) child],
        ),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}

Widget buildListItem(
  BuildContext context, {
  required String title,
  required IconData leading,
  required VoidCallback onpressed,
  bool isActive = true,
}) {
  final theme = Theme.of(context);

  return InkWell(
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: isActive
          ? TextButton(
              style: const ButtonStyle(),
              onPressed: onpressed,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (leading != null)
                      Icon(
                        leading,
                        color: Colors.white,
                      ),
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          child: Text(title),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (leading != null)
                    Icon(
                      leading,
                      color: const Color.fromARGB(83, 255, 255, 255),
                    ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Color.fromARGB(83, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    ),
  );
}
