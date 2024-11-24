import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  User? getCurrentUser();
}
