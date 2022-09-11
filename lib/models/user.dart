import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String fullName;
  final String username;
  final String bio;
  final String createdAt;

  final List followers;
  final List following;

  const User(
      {required this.fullName,
      required this.username,
      required this.uid,
      required this.photoUrl,
      required this.email,
      required this.bio,
      required this.createdAt,
      required this.followers,
      required this.following});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      fullName: snapshot['fullName'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      photoUrl: snapshot['photoUrl'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      createdAt: snapshot['createdAt'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }

  Map<String, dynamic> toJsaon() => {
        'fullName': fullName,
        'username': username,
        'uid': uid,
        'photoUrl': photoUrl,
        'email': email,
        'bio': bio,
        'createdAt': createdAt,
        'followers': followers,
        'following': following,
      };
}
