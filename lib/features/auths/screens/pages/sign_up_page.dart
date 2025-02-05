import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/features/auths/controller/auth_controller.dart';
import 'package:yappr/features/auths/screens/widgets/auth_field.dart';
import 'package:yappr/features/auths/screens/widgets/auth_gradient_button.dart';
import 'package:yappr/core/Theme/app_pallete.dart';

class SignUpPage extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const SignUpPage({super.key, required this.onTap});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  void signUp(BuildContext context) {
    ref.read(authControllerProvider.notifier).signUpWithEmailPassword(
          context: context,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                Text(
                  'Sign Up.',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                AuthField(
                  hintText: 'Name',
                  textEditingController: nameController,
                ),
                SizedBox(
                  height: 15,
                ),
                AuthField(
                  hintText: 'Email',
                  textEditingController: emailController,
                ),
                SizedBox(
                  height: 15,
                ),
                AuthField(
                  hintText: 'Password',
                  textEditingController: passwordController,
                  isObscure: true,
                ),
                SizedBox(
                  height: 15,
                ),
                AuthField(
                  hintText: 'Phone Number',
                  textEditingController: phoneNumberController,
                  isNumber: true,
                ),
                SizedBox(
                  height: 15,
                ),
                AuthGradientButton(
                  title: 'Sign Up',
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      signUp(context);
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: RichText(
                    text:
                        TextSpan(text: 'Already have an account? ', children: [
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppPallete.gradient2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
