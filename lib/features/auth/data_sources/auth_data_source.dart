import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';

abstract class AuthDataSource {
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithGoogle();

  Future<Either<Failure, User>> loginWithFacebook();

  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber({
    required String phoneNumber,
    required bool isLinking,
  });

  Future<Either<Failure, User>> verifyOtpCode({
    required String verificationId,
    required String otp,
    required bool isLinking,
  });

  Future<Either<Failure, Unit>> logout();

  User? getCurrentUser();
}
