import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/either.dart';
import '../../models/failure.dart';
import '../../utils/app_strings.dart';
import 'phone_data_source.dart';

class FirebasePhoneDataSource implements PhoneDataSource {
  final FirebaseAuth _auth;

  FirebasePhoneDataSource({required FirebaseAuth auth}) : _auth = auth;
  @override
  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber({
    required String phoneNumber,
    required bool isLinking,
  }) async {
    try {
      final completer = Completer<Either<Failure, Either<String, User>>>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          try {
            final userCredential = isLinking
                ? await _auth.currentUser!.linkWithCredential(credential)
                : await _auth.signInWithCredential(credential);
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
    required bool isLinking,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final userCredential = isLinking
                ? await _auth.currentUser!.linkWithCredential(credential)
                : await _auth.signInWithCredential(credential);

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
}