import 'package:chat/core/models/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/failure.dart';

abstract class EmailSettingsDataSource {
  Future<Either<Failure, User>> updateEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> linkEmail({
    required String email,
    required String password,
  });

  Stream<User?> userChanges();

  Future<Either<Failure, UserCredential>> reauthenticateWithCredential({
    required String email,
    required String password,
  });
}
