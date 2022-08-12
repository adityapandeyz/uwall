import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uwall/widgets/custom_button.dart';
import 'package:uwall/widgets/custom_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadScreen extends StatefulWidget {
  static const String routeName = '/upload-screen';

  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final formKey = GlobalKey<FormState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser!;

  final controllerTitle = TextEditingController();
  final controllerComment = TextEditingController();

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
                // Center(
                //   child: GestureDetector(
                //     onTap: () {
                //     },
                //     child: Container(
                //       child: _image != null
                //           ? CircleAvatar(
                //               radius: 64,
                //               backgroundImage: MemoryImage(_image!),
                //             )
                //           : Container(
                //               decoration: BoxDecoration(
                //                   color: Colors.grey[200],
                //                   borderRadius: BorderRadius.circular(50)),
                //               width: 100,
                //               height: 100,
                //               child: Icon(
                //                 Icons.camera_alt,
                //                 color: Colors.grey[800],
                //               ),
                //             ),
                //     ),
                //   ),
                // ),
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
