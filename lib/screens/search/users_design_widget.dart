import 'package:flutter/material.dart';
import 'package:uwall/screens/profile_screen.dart';
import 'package:uwall/utils/colors.dart';

import 'user.dart';

class UsersDesignWidget extends StatefulWidget {
  Users? model;
  BuildContext? context;

  UsersDesignWidget({
    Key? key,
    this.model,
    this.context,
  }) : super(key: key);

  @override
  State<UsersDesignWidget> createState() => _UsersDesignWidgetState();
}

class _UsersDesignWidgetState extends State<UsersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              userId: widget.model!.id!,
            ),
          ),
        );
      },
      child: Card(
        color: secondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: SizedBox(
            //height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        widget.model!.userImage!,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model!.name!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Bebas',
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            widget.model!.email!,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
