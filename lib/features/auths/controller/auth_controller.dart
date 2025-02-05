import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yappr/features/auths/repository/auth_repository.dart';
import 'package:yappr/core/constants/utils.dart';
import 'package:yappr/models/usermodel.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(
      authRepositoryProvider,
    ),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithEmailPassword({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      state = true;
      final user = await _authRepository.signInWithEmailPassword(
          email: email, password: password);
      state = false;

      user.fold((l) => showSnackBar(context, l.message), (userModel) {
        _ref.watch(userProvider.notifier).update((state) => userModel);
      });
    } on FirebaseException catch (e) {
      if (mounted) {
        showSnackBar(context, e.message!);
      }
    }
  }

  void signUpWithEmailPassword({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    state = true;
    final user = await _authRepository.signUpWithEmailPassword(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
    state = false;

    user.fold((l) {
      showSnackBar(context, l.message);
    }, (userModel) {
      _ref.watch(userProvider.notifier).update((state) => userModel);
    });
  }

  void logOut() {
    _authRepository.logOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
