import 'package:chat/core/utils/app_strings.dart';

import '../../../core/data_sources/user_data_source.dart';
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
        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email,
          profilePictureUrl: AppStrings.emptyString,
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
      (user) async => await _userDataSource.fetchOrSaveUser(user),
    );
  }

  @override
  Future<Either<Failure, UserModel>> loginWithFacebook() async {
    final authResult = await _authDataSource.loginWithFacebook();
    return authResult.fold(
      (failure) => Either.left(failure),
      (user) async => await _userDataSource.fetchOrSaveUser(user),
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
