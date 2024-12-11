import 'package:firebase_auth/firebase_auth.dart';

import '../../enums/phone_auth_type.dart';
import '../../models/either.dart';
import '../../models/failure.dart';

abstract class PhoneDataSource {
  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneAuthType phoneAuthType,
  });

  Future<Either<Failure, User>> verifyOtpCode({
    required String verificationId,
    required String otp,
    required PhoneAuthType phoneAuthType,
  });
}