import 'package:chat/core/repos/phone/phone_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data_sources/phone/phone_data_source.dart';
import '../../enums/phone_auth_type.dart';
import '../../models/either.dart';
import '../../models/failure.dart';

class FirebasePhoneRepository implements PhoneRepository {
  final PhoneDataSource _phoneDataSource;

  FirebasePhoneRepository({required PhoneDataSource phoneDataSource})
      : _phoneDataSource = phoneDataSource;
  @override
  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneAuthType phoneAuthType,
  }) async {
    final result = await _phoneDataSource.verifyPhoneNumber(
        phoneNumber: phoneNumber, phoneAuthType: phoneAuthType);

    return result.fold(
      (failure) => Either.left(failure),
      (value) async {
        return value.fold(
          (verificationId) => Either.right(Either.left(verificationId)),
          (user) async {
            return Either.right(Either.right(user));
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, User>> verifyOtpCode({
    required String verificationId,
    required String otp,
    required PhoneAuthType phoneAuthType,
  }) async {
    final result = await _phoneDataSource.verifyOtpCode(
      verificationId: verificationId,
      otp: otp,
      phoneAuthType: phoneAuthType,
    );

    return result.fold(
      (failure) => Either.left(failure),
      (user) async {
        return Either.right(user);
      },
    );
  }
}
