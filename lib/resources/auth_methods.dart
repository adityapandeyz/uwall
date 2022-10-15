import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../resources/storage_methods.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

// Signing Up User

  Future<String> signUpUser({
    required String fullName,
    required String email,
    required String password,
    required File file,
  }) async {
    String res = "Some error occurred";

    try {
      if (fullName.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          file != null) {
        // resginstering user in auth with email and password

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User _user = model.User(
          fullName: fullName,
          username: '',
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl,
          bio: '',
          createdAt: DateTime.now().toString(),
          followers: [],
          following: [],
        );

        //adding user in our database
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(_user.toJsaon());

        res = "success";
      } else {
        res = 'Empty field(s)!';
      }
    } catch (error) {
      return error.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
