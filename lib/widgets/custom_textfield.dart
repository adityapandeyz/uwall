import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final int lines;
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
    required this.lines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: lines,
      controller: controller,
      keyboardType: TextInputType.text,

      //placeholder: hintText,

      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        contentPadding: const EdgeInsets.only(
            left: 18.0, bottom: 10.0, top: 12.0, right: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: customTextFieldValidator,

      obscureText: obsecureText,
    );
  }
}
