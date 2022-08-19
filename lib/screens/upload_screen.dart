import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uwall/utils/colors.dart';
import 'package:uwall/widgets/custom_button.dart';
import 'package:uwall/widgets/custom_textfield.dart';

import 'profile_screen.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;

  Future checkEmailVerified() async {
    //Call after email verificaton
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) return;
  }

  @override
  Widget build(BuildContext context) =>
      isEmailVerified ? const UploadScreen() : const VerifyEmail();
}

class UploadScreen extends StatefulWidget {
  static const String routeName = '/upload-screen';

  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imagefile;
  String? imageUrl;
  String? myImage;
  String? myName;
  String _category = '';

  // final TextEditingController _controllerTitle =
  //     TextEditingController(text: "");

  final _controllerTitle = TextEditingController();
  //final controllerComment = TextEditingController();

  @override
  void dispose() {
    _controllerTitle.dispose();
    //controllerComment.dispose();
    super.dispose();
  }

  void _showImageDialoge() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          title: const Text("Please choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (() {
                      _getFromGallery();
                    }),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image_rounded,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile?.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        imagefile = File(croppedImage.path);
      });
    }
  }

  List<S2Choice<String>> days = [
    S2Choice<String>(value: '3d', title: '3D'),
    S2Choice<String>(value: 'abstract', title: 'Abstract'),
    S2Choice<String>(value: 'animals', title: 'Animals'),
    S2Choice<String>(value: 'anime', title: 'Anime'),
    S2Choice<String>(value: 'art', title: 'Art'),
    S2Choice<String>(value: 'cars', title: 'Cars'),
    S2Choice<String>(value: 'city', title: 'City'),
    S2Choice<String>(value: 'dark', title: 'Dark'),
    S2Choice<String>(value: 'fantasy', title: 'Fantasy'),
    S2Choice<String>(value: 'games', title: 'Games'),
    S2Choice<String>(value: 'movies', title: 'Movies'),
    S2Choice<String>(value: 'nature', title: 'Nature'),
    S2Choice<String>(value: 'others', title: 'Others'),
    S2Choice<String>(value: 'space', title: 'Space'),
    S2Choice<String>(value: 'sports', title: 'Sports'),
    S2Choice<String>(value: 'technology', title: 'Technology'),
    S2Choice<String>(value: 'textures', title: 'Textures'),
    S2Choice<String>(value: 'vectore', title: 'Vector'),
    S2Choice<String>(value: 'words', title: 'Words'),
  ];

  void read_userInfo() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then<dynamic>(
      (DocumentSnapshot snapshot) async {
        myImage = snapshot.get('userImage');
        myName = snapshot.get('name');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    read_userInfo();
  }

  void _upload_image() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (imagefile == null) {
      Fluttertoast.showToast(msg: 'Please Select an Image');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      return;
    } else if (_category == null) {
      Fluttertoast.showToast(msg: 'Please choose the category');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      return;
    }
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("userImages")
          .child("${DateTime.now()}.jpg");

      await ref.putFile(imagefile!);

      imageUrl = await ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection("wallpaper")
          .doc(DateTime.now().toString())
          .set(
        {
          'id': _auth.currentUser!.uid,
          'userImage': myImage.toString(),
          'userName': myName.toString(),
          'email': _auth.currentUser!.email,
          'title': _controllerTitle.text.trim(),
          'Image': imageUrl,
          'Category': _category.toString(),
          'downloads': 0,
          'createdAt': DateTime.now(),
        },
      );
      Fluttertoast.showToast(msg: 'Wallpaper uploaded successfully');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      imagefile = null;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userId: _auth.currentUser!.uid,
          ),
        ),
      );
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      Navigator.canPop(context) ? Navigator.pop(context) : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _controllerTitle,
                  hintText: 'Title',
                  obsecureText: false,
                ),
                const SizedBox(height: 10),
                SmartSelect<String>.single(
                  title: 'Category',
                  selectedValue: _category,
                  choiceItems: days,
                  onChange: (selected) => setState(
                    () => _category = selected.value,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showImageDialoge();
                    },
                    child: Container(
                      child: imagefile != null
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3.5,
                              child: Image(image: Image.file(imagefile!).image),
                            )

                          //  CircleAvatar(
                          //     radius: 64,
                          //     backgroundImage: Image.file(imagefile!).image,
                          //   )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3.5,
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey[800],
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Upload',
                  onTap: () {
                    _upload_image();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
