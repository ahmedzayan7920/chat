import 'package:chat/core/repos/phone/phone_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data_sources/phone/phone_data_source.dart';
import '../../models/either.dart';
import '../../models/failure.dart';

class FirebasePhoneRepository implements PhoneRepository {
  final PhoneDataSource _phoneDataSource;

  FirebasePhoneRepository({required PhoneDataSource phoneDataSource})
      : _phoneDataSource = phoneDataSource;
  @override
  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber({
    required String phoneNumber,
    required bool isLinking,
  }) async {
    final result = await _phoneDataSource.verifyPhoneNumber(
        phoneNumber: phoneNumber, isLinking: isLinking);

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
    required bool isLinking,
  }) async {
    final result = await _phoneDataSource.verifyOtpCode(
      verificationId: verificationId,
      otp: otp,
      isLinking: isLinking,
    );

    return result.fold(
      (failure) => Either.left(failure),
      (user) async {
        return Either.right(user);
      },
    );
  }
}
