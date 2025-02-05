import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/features/auths/controller/auth_controller.dart';
import 'package:yappr/core/Theme/theme.dart';
import 'package:yappr/core/commons/loader.dart';
import 'package:yappr/core/constants/error_text.dart';
import 'package:yappr/features/auths/screens/pages/login_or_signup_page.dart';
import 'package:yappr/features/chat/screens/pages/chat_screen.dart';
import 'package:yappr/models/usermodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.watch(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (user) {
          if (user != null) {
            getData(ref, user);
          }
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Yappr',
              theme: AppTheme.darkTheme,
              home: (user != null && userModel != null) ? ChatScreen(uid: user.uid) : const LoginOrSignupPage(),
            );
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
