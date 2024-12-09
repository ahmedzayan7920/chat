import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import '../../../core/utils/app_strings.dart';
import '../data_sources/auth_data_source.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AuthDataSource _authDataSource;

  FirebaseAuthRepository({
    required AuthDataSource authDataSource,
  }) : _authDataSource = authDataSource;

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final authResult = await _authDataSource.registerWithEmailAndPassword(
        email: email, password: password);

    return authResult.fold(
      (failure) => Either.left(failure),
      (user) => Either.right(user),
    );
  }

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authResult = await _authDataSource.loginWithEmailAndPassword(
        email: email, password: password);

    return authResult.fold(
      (failure) => Either.left(failure),
      (user) => Either.right(user),
    );
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    final authResult = await _authDataSource.loginWithGoogle();

    return authResult.fold(
      (failure) => Either.left(failure),
      (user) async {
        return Either.right(user);
      },
    );
  }

  @override
  Future<Either<Failure, User>> loginWithFacebook() async {
    final authResult = await _authDataSource.loginWithFacebook();
    return authResult.fold(
      (failure) => Either.left(failure),
      (user) async {
        return Either.right(user);
      },
    );
  }

  @override
  Future<Either<Failure, Either<String, User>>> verifyPhoneNumber({
    required String phoneNumber,
    required bool isLinking,
  }) async {
    final result = await _authDataSource.verifyPhoneNumber(
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
    final result = await _authDataSource.verifyOtpCode(
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

  @override
  Future<Either<Failure, Unit>> logout() async {
    return await _authDataSource.logout();
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    final user = _authDataSource.getCurrentUser();

    if (user == null) {
      return Either.left(const Failure(AppStrings.userNotFound));
    }
    return Either.right(user);
  }
}
