import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../enums/phone_auth_type.dart';
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
    required PhoneAuthType phoneAuthType,
  }) async {
    final completer = Completer<Either<Failure, Either<String, User>>>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) => _handleVerificationCompleted(
          credential: credential,
          phoneAuthType: phoneAuthType,
          completer: completer,
        ),
        verificationFailed: (error) => completer.complete(
          Either.left(Failure.fromException(error)),
        ),
        codeSent: (verificationId, _) => completer.complete(
          Either.right(Either.left(verificationId)),
        ),
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
    required PhoneAuthType phoneAuthType,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final user = await _processCredential(credential, phoneAuthType);
      return _validateUser(user).fold(
        (failure) => Either.left(failure),
        (userOrString) => userOrString.fold(
          (verificationId) => Either.left(const Failure(AppStrings.userIsNull)),
          (user) => Either.right(user),
        ),
      );
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<void> _handleVerificationCompleted({
    required PhoneAuthCredential credential,
    required PhoneAuthType phoneAuthType,
    required Completer<Either<Failure, Either<String, User>>> completer,
  }) async {
    try {
      final user = await _processCredential(credential, phoneAuthType);
      completer.complete(_validateUser(user));
    } catch (e) {
      completer.complete(Either.left(Failure.fromException(e)));
    }
  }

  Future<User?> _processCredential(
    PhoneAuthCredential credential,
    PhoneAuthType phoneAuthType,
  ) async {
    switch (phoneAuthType) {
      case PhoneAuthType.auth:
        final userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;

      case PhoneAuthType.link:
        final userCredential =
            await _auth.currentUser!.linkWithCredential(credential);
        return userCredential.user;

      case PhoneAuthType.update:
        await _auth.currentUser!.updatePhoneNumber(credential);
        return _auth.currentUser;
    }
  }

  Either<Failure, Either<String, User>> _validateUser(User? user) {
    return user != null
        ? Either.right(Either.right(user))
        : Either.left(const Failure(AppStrings.autoVerificationFailed));
  }
}
