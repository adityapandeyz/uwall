import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uwall/screens/search/user.dart';
import 'package:uwall/screens/search/users_design_widget.dart';
import 'package:uwall/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? postDocumentsList;

  String userNameText = "";

  initSearchingPost(String textEntered) {
    postDocumentsList = FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: textEntered)
        .get();

    setState(
      () {
        postDocumentsList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          onChanged: (textEntered) {
            setState(
              () {
                userNameText = textEntered;
              },
            );
            initSearchingPost(textEntered);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: secondaryColor,
            // contentPadding:
            //     const EdgeInsets.only(left: 18.0, bottom: 10.0, top: 12.0),
            border: InputBorder.none,
            hintText: 'Seach Users here...',
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                initSearchingPost(userNameText);
              },
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
      body: FutureBuilder<QuerySnapshot>(
        future: postDocumentsList,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    Users model = Users.fromJson(snapshot.data!.docs[index]
                        .data()! as Map<String, dynamic>);
                    return UsersDesignWidget(
                      model: model,
                      context: context,
                    );
                  }),
                )
              : const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.search,
                    size: 200,
                    color: Color.fromARGB(61, 124, 124, 124),
                  ),
                );
        },
      ),
    );
  }
}
