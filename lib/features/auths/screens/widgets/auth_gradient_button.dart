import 'package:flutter/material.dart';
import 'package:yappr/core/Theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AuthGradientButton({super.key,required this.title,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppPallete.gradient1,AppPallete.gradient2,AppPallete.gradient3],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)),
        ),
    );
  }
}