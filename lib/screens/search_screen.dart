import 'package:flutter/material.dart';
import 'package:uwall/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          onChanged: (textEntered) {
            // setState(() {
            //   userNameText = textEntered;
            // });
            // initSearchingPost(textEntered);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: secondaryColor,
            // contentPadding:
            //     const EdgeInsets.only(left: 18.0, bottom: 10.0, top: 12.0),
            border: InputBorder.none,
            hintText: 'Seach Post here....',
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            prefixIcon: IconButton(
              icon: const Padding(
                padding: EdgeInsets.only(right: 12.0, bottom: 4.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/home-screen');
              },
            ),
          ),
        ),
      ),
      body: const Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.search,
          size: 200,
          color: Color.fromARGB(61, 124, 124, 124),
        ),
      ),
    );
  }
}
