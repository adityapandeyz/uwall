import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool ObsecureText;
  final CustomTextFieldValidator;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.ObsecureText,
    this.CustomTextFieldValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black38),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: CustomTextFieldValidator,
      obscureText: ObsecureText,
    );
  }
}
