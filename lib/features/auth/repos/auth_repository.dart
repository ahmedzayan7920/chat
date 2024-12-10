import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import '../../../core/repos/phone/phone_repository.dart';

abstract class AuthRepository extends PhoneRepository {
  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithGoogle();

  Future<Either<Failure, User>> loginWithFacebook();

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, User>> getCurrentUser();
}
