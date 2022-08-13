import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uwall/utils/colors.dart';
import 'package:uwall/widgets/custom_button.dart';
import 'package:uwall/widgets/custom_textfield.dart';

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

  final controllerTitle = TextEditingController();
  final controllerComment = TextEditingController();

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

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerComment.dispose();
    super.dispose();
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
                  controller: controllerTitle,
                  hintText: 'Title',
                  obsecureText: false,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: controllerComment,
                  hintText: 'Comment',
                  obsecureText: false,
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
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
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
