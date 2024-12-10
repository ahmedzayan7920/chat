import 'package:firebase_auth/firebase_auth.dart';

import '../../models/either.dart';
import '../../models/failure.dart';

abstract class PhoneRepository {
  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber({
    required String phoneNumber,
    required bool isLinking,
  });

  Future<Either<Failure, User>> verifyOtpCode({
    required String verificationId,
    required String otp,
    required bool isLinking,
  });
}