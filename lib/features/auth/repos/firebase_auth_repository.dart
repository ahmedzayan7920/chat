import 'package:chat/core/utils/app_strings.dart';

import '../../users/data_sources/user_data_source.dart';
import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import '../../../core/models/user_model.dart';
import '../data_sources/auth_data_source.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final AuthDataSource _authDataSource;
  final UserDataSource _userDataSource;

  FirebaseAuthRepository({
    required AuthDataSource authDataSource,
    required UserDataSource userDataSource,
  })  : _authDataSource = authDataSource,
        _userDataSource = userDataSource;

  @override
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final authResult = await _authDataSource.registerWithEmailAndPassword(
        email: email, password: password);

    return authResult.fold(
      (failure) => Either.left(failure),
      (user) async {
        final userModel = UserModel.newUser(
          id: user.uid,
          name: name,
          email: email,
        );
        final saveResult = await _userDataSource.storeUserToDatabase(userModel);
        return saveResult.fold(
          (failure) => Either.left(failure),
          (_) => Either.right(userModel),
        );
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final authResult = await _authDataSource.loginWithEmailAndPassword(
        email: email, password: password);

    return authResult.fold(
      (failure) => Either.left(failure),
      (user) => _userDataSource.fetchUserFromDatabase(user.uid),
    );
  }

  @override
  Future<Either<Failure, UserModel>> loginWithGoogle() async {
    final authResult = await _authDataSource.loginWithGoogle();

    return authResult.fold(
      (failure) => Either.left(failure),
      (user) async {
        final userModel = UserModel.newUser(
          id: user.uid,
          name: user.displayName ?? AppStrings.emptyString,
          email: user.email ?? AppStrings.emptyString,
          profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
        );
        return await _userDataSource.fetchOrSaveUser(userModel);
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> loginWithFacebook() async {
    final authResult = await _authDataSource.loginWithFacebook();
    return authResult.fold(
      (failure) => Either.left(failure),
      (user) async {
        final userModel = UserModel.newUser(
          id: user.uid,
          name: user.displayName ?? AppStrings.emptyString,
          email: user.email ?? AppStrings.emptyString,
          profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
        );
        return await _userDataSource.fetchOrSaveUser(userModel);
      },
    );
  }

  @override
  Future<Either<Failure, Either<String, UserModel>>> verifyPhoneNumber({
    required String phoneNumber,
  }) async {
    final result =
        await _authDataSource.verifyPhoneNumber(phoneNumber: phoneNumber);

    return result.fold(
      (failure) => Either.left(failure),
      (value) async {
        return value.fold(
          (verificationId) => Either.right(Either.left(verificationId)),
          (user) async {
            final userModel = UserModel.newUser(
              id: user.uid,
              name: user.displayName ?? AppStrings.emptyString,
              email: user.email ?? AppStrings.emptyString,
              profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
            );

            final fetchOrSaveResult =
                await _userDataSource.fetchOrSaveUser(userModel);

            return fetchOrSaveResult.fold(
              (failure) => Either.left(failure),
              (userModel) => Either.right(Either.right(userModel)),
            );
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> verifyOtpCode({
    required String verificationId,
    required String otp,
  }) async {
    final result = await _authDataSource.verifyOtpCode(
      verificationId: verificationId,
      otp: otp,
    );

    return result.fold(
      (failure) => Either.left(failure),
      (user) async {
        final userModel = UserModel.newUser(
          id: user.uid,
          name: user.displayName ?? AppStrings.emptyString,
          email: user.email ?? AppStrings.emptyString,
          profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
        );
        return await _userDataSource.fetchOrSaveUser(userModel);
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return await _authDataSource.logout();
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    final user = _authDataSource.getCurrentUser();

    if (user == null) {
      return Either.left(const Failure(AppStrings.userNotFound));
    }

    final result = await _userDataSource.fetchUserFromDatabase(user.uid);
    return result.fold(
      (failure) => Either.left(failure),
      (userModel) => Either.right(userModel),
    );
  }
}
