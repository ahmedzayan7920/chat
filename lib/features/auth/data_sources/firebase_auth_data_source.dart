import 'dart:async';

import 'package:chat/core/data_sources/phone/firebase_phone_data_source.dart';
import 'package:chat/core/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import 'auth_data_source.dart';

class FirebaseAuthDataSource extends FirebasePhoneDataSource
    implements AuthDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  FirebaseAuthDataSource({
    required super.auth,
    required GoogleSignIn googleSignIn,
    required FacebookAuth facebookAuth,
  })  : _auth = auth,
        _googleSignIn = googleSignIn,
        _facebookAuth = facebookAuth;

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Either.right(credential.user!);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        return Either.left(const Failure(AppStrings.userNotFound));
      }
      await credential.user!.updateDisplayName(name);
      return Either.right(_auth.currentUser!);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Either.left(const Failure(AppStrings.googleLoginAborted));
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return Either.right(userCredential.user!);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithFacebook() async {
    try {
      final result = await _facebookAuth.login();

      if (result.status == LoginStatus.success) {
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        final userCredential = await _auth.signInWithCredential(credential);
        return Either.right(userCredential.user!);
      } else {
        return Either.left(Failure('${result.message}'));
      }
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _auth.signOut();
      return Either.right(const Unit());
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    _auth.currentUser?.reload();
    return Future.value(_auth.currentUser);
  }
}
