import 'package:flutter/material.dart';
import 'package:uwall/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final customTextFieldValidator;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obsecureText,
    this.customTextFieldValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: secondaryColor,
        contentPadding:
            const EdgeInsets.only(left: 18.0, bottom: 10.0, top: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: customTextFieldValidator,
      obscureText: obsecureText,
    );
  }
}
