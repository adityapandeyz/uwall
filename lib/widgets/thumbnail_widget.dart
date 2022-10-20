import 'package:flutter/material.dart';
import 'package:scale_button/scale_button.dart';
import 'package:uwall/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ThubmnailWidget extends StatelessWidget {
  final String image;
  final String title;
  final int downloads;
  final VoidCallback onTap;
  const ThubmnailWidget({
    super.key,
    required this.image,
    required this.title,
    required this.downloads,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      bound: 0.05,
      duration: const Duration(milliseconds: 170),
      child: InkWell(
        // splashColor: Colors.grey,
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints.expand(
            height: 200.0,
          ),
          padding: const EdgeInsets.only(top: 220.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                image,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.download_rounded,
                            size: 11,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '$downloads',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
