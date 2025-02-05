import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/features/auths/controller/auth_controller.dart';
import 'package:yappr/features/auths/screens/widgets/auth_field.dart';
import 'package:yappr/features/auths/screens/widgets/auth_gradient_button.dart';
import 'package:yappr/core/Theme/app_pallete.dart';

class LoginPage extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  void signIn(BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithEmailPassword(
          context: context,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
        );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign In.',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
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
              AuthGradientButton(
                title: 'Sign In',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    signIn(context);
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: RichText(
                  text: TextSpan(text: 'Don\'t have an account? ', children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppPallete.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
