import 'dart:async';

import 'package:chat/core/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import 'auth_data_source.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  FirebaseAuthDataSource({
    required FirebaseAuth auth,
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
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Either.right(credential.user!);
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
        return Either.left(const Failure('Google sign-in aborted.'));
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
  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber(
      {required String phoneNumber}) async {
    try {
      final completer = Completer<Either<Failure, Either<String, User>>>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          try {
            final userCredential = await _auth.signInWithCredential(credential);
            final user = userCredential.user;

            if (user != null) {
              completer.complete(
                Either.right(Either.right(user)),
              );
            } else {
              completer.complete(Either.left(
                  const Failure(AppStrings.autoVerificationFailed)));
            }
          } catch (e) {
            completer.complete(Either.left(Failure.fromException(e)));
          }
        },
        verificationFailed: (error) {
          completer.complete(Either.left(Failure.fromException(error)));
        },
        codeSent: (verificationId, resendToken) {
          completer.complete(
            Either.right(Either.left(verificationId)),
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );

      return await completer.future;
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtpCode({
    required String verificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        return Either.right(user);
      } else {
        return Either.left(const Failure(AppStrings.userIsNull));
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
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
