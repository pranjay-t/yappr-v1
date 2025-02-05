import 'package:flutter/material.dart';
import 'package:yappr/features/auths/screens/pages/login_page.dart';
import 'package:yappr/features/auths/screens/pages/sign_up_page.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  bool showLoginPage = true;

  void  togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return  LoginPage(
        onTap: togglePages,
      );
    } else {
      return  SignUpPage(
        onTap: togglePages,
      );
    }
  }
}
