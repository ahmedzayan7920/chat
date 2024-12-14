import 'package:chat/core/data_sources/phone/phone_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';

abstract class AuthDataSource extends PhoneDataSource {
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithGoogle();

  Future<Either<Failure, User>> loginWithFacebook();

  Future<Either<Failure, Unit>> logout();

  Future<User?> getCurrentUser();
}
