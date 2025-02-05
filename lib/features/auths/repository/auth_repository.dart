import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:yappr/core/constants/failure.dart';
import 'package:yappr/core/constants/firebase_constants.dart';
import 'package:yappr/core/constants/type_def.dart';
import 'package:yappr/core/providers/auth_provider.dart';
import 'package:yappr/models/usermodel.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential;
      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel = await getUserData(userCredential.user!.uid).first;

      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signUpWithEmailPassword({
  required String name,
  required String email,
  required String password,
  required String phoneNumber,
}) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String profilePic = _getGravatarUrl(email);

    UserModel userModel = UserModel(
      name: name,
      profilePic: profilePic,
      uid: userCredential.user!.uid,
      email: email,
      phoneNumber: phoneNumber,
    );

    await _users.doc(userCredential.user!.uid).set(userModel.toMap());

    return right(userModel);
  } on FirebaseAuthException catch (e) {
    return left(Failure(e.message!));
  } catch (e) {
    return left(Failure(e.toString()));
  }
}

  void logOut() async {
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  String _getGravatarUrl(String email) {
    final gravatarBaseUrl = "https://www.gravatar.com/avatar/";
    final emailHash = md5.convert(utf8.encode(email.trim().toLowerCase())).toString();
    return "$gravatarBaseUrl$emailHash?s=200&d=identicon";
  }

  CollectionReference get _users => _firestore.collection(
        FirebaseConstants.usersCollection,
      );
}
