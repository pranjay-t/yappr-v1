import 'package:flutter/material.dart';
import 'package:yappr/core/Theme/app_pallete.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool isObscure;
  final bool isNumber;
  const AuthField(
      {super.key,
      required this.hintText,
      required this.textEditingController,
      this.isObscure = false,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    border([color = AppPallete.borderColor]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 3,
            color: color,
          ),
        );
    return TextFormField(
      obscureText: isObscure,
      controller: textEditingController,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        if (isNumber) {
          final number = int.tryParse(value);
          if (number == null || value.length < 10) {
            return 'Please enter a valid number with at least 10 digits.';
          }
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(25),
        hintText: hintText,
        enabledBorder: border(),
        focusedBorder: border(AppPallete.gradient2),
      ),
    );
  }
}
