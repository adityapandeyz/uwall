import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uwall/utils/colors.dart';

import '../../main.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup-screen';

  const SignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  File? imagefile;
  String? imageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

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
                  InkWell(
                    onTap: (() {
                      _getFromCamera();
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
                        Icons.camera_alt_rounded,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        imagefile != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: Image.file(imagefile!).image,
                              )
                            : const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 105, 105, 105),
                                radius: 64,
                                child: Icon(
                                  Icons.account_circle_rounded,
                                  size: 100,
                                ),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 86,
                          child: IconButton(
                            onPressed: () {
                              _showImageDialoge();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Name',
                      obsecureText: false,
                      customTextFieldValidator: (value) =>
                          value != null && value.length < 2
                              ? 'Enter min. 2 characters'
                              : null,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      obsecureText: false,
                      customTextFieldValidator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a Valid email'
                              : null,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obsecureText: true,
                      customTextFieldValidator: (value) =>
                          value != null && value.length < 6
                              ? 'Enter min. 6 characters '
                              : null,
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    CustomButton(
                      text: 'Sign Up',
                      onTap: signUp,
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

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    if (imagefile == null) {
      Fluttertoast.showToast(msg: "Please select an Image");
      return;
    }
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("userImages")
          .child('${DateTime.now()}.jpg');

      await ref.putFile(imagefile!);

      imageUrl = await ref.getDownloadURL();

      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim().toString(),
        password: _passwordController.text.trim(),
      );

      final User? user = _auth.currentUser;
      final uid = user!.uid;

      FirebaseFirestore.instance.collection('users').doc(uid).set({
        "id": uid,
        "userImage": imageUrl,
        "name": _nameController.text,
        "email": _emailController.text,
        "createdAt": Timestamp.now(),
      });

      Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
      );
    }

    //Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
