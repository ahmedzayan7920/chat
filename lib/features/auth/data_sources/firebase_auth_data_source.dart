import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import 'auth_data_source.dart';

class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _auth;

  FirebaseAuthDataSource({required FirebaseAuth auth}) : _auth = auth;

  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Either.right(credential.user!);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Either.right(credential.user!);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _auth.signOut();
      return Either.right(const Unit());
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
