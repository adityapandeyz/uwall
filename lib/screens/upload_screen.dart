import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../resources/storage_methods.dart';
import '../screens/home_screen.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/popover.dart';
import '../widgets/sign_in_widget.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool isUserLoggedIn = false;

  checkUserLoginState() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isUserLoggedIn = true;
      });
    }
    return isUserLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return checkUserLoginState()
        ? const UploadPage()
        : Scaffold(
            appBar: AppBar(
              title: Text('Upload'),
            ),
            body: const SignInWidget());
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imagefile;
  String? imageUrl;
  String? myImage;
  String? myName;
  String _category = '';

  // final TextEditingController _controllerTitle =
  //     TextEditingController(text: "");

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  void _showImageDialoge() {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       backgroundColor: const Color.fromARGB(255, 29, 29, 29),
    //       title: const Text("Please choose an option"),
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               InkWell(
    //                 onTap: (() {
    //                   _getFromGallery();
    //                 }),
    //                 child: Container(
    //                   height: 80,
    //                   width: 80,
    //                   decoration: BoxDecoration(
    //                     color: Colors.grey,
    //                     shape: BoxShape.rectangle,
    //                     borderRadius: BorderRadius.circular(12),
    //                   ),
    //                   child: const Icon(
    //                     Icons.image_rounded,
    //                     size: 40,
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(width: 20),
    //             ],
    //           )
    //         ],
    //       ),
    //     );
    //   },
    //);

    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: Column(
            children: [
              buildListItem(
                context,
                title: 'Select from gallery',
                leading: Icons.image_rounded,
                onpressed: _getFromGallery,
              ),
              // buildListItem(
              //   context,
              //   title: 'Take a photo',
              //   leading: Icons.camera_enhance_rounded,
              //   onpressed: _getFromCamera,
              // ),
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
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          // toolbarColor: secondaryColor,
          activeControlsWidgetColor: primaryColor,
          // toolbarWidgetColor: secondaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );

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
        myImage = snapshot.get('photoUrl');
        myName = snapshot.get('fullName');
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
      showSnackBar(context, 'Please select an image!');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      return;
    } else if (_category.toString().isEmpty) {
      showSnackBar(context, 'Please choose the category!');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      return;
    } else if (_titleController.text.isEmpty) {
      showSnackBar(context, 'Please enter the title!');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      return;
    } else if (_descriptionController.text.isEmpty) {
      showSnackBar(context, 'Please enter description');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      return;
    }
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('wallpapers', imagefile!, true);
      String wallpaperId = const Uuid().v1();

      FirebaseFirestore.instance.collection("wallpapers").doc(wallpaperId).set(
        {
          'uid': _auth.currentUser!.uid,
          'wallpaperId': wallpaperId,
          'userImage': myImage.toString(),
          'fullName': myName.toString(),
          'email': _auth.currentUser!.email,
          'title': _titleController.text,
          'image': photoUrl,
          'description': _descriptionController.text,
          'category': _category.toString(),
          'downloads': 0,
          'likes': [],
          'createdAt': DateTime.now(),
        },
      );
      showSnackBar(context, 'Wallpaper uploaded successfully!');
      Navigator.canPop(context) ? Navigator.pop(context) : null;
      imagefile = null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (error) {
      showSnackBar(context, error.toString());
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
                const SizedBox(height: 10),
                CustomTextField(
                  lines: 1,
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  hintText: 'Title',
                  obsecureText: false,
                  customTextFieldValidator: (value) =>
                      value != null && value.length < 2
                          ? "This field can't be null"
                          : null,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  textInputAction: TextInputAction.done,
                  lines: 4,
                  controller: _descriptionController,
                  hintText: 'Description...',
                  obsecureText: false,
                  customTextFieldValidator: (value) =>
                      value != null && value.length < 2
                          ? "This field can't be null"
                          : null,
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
                CustomButton(
                  text: 'UPLOAD',
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
