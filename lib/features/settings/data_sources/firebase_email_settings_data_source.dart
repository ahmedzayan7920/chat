import 'package:chat/core/models/either.dart';
import 'package:chat/core/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/failure.dart';
import 'email_settings_data_source.dart';

class FirebaseEmailSettingsDataSource implements EmailSettingsDataSource {
  final FirebaseAuth _auth;

  FirebaseEmailSettingsDataSource({required FirebaseAuth auth}) : _auth = auth;

  @override
  Future<Either<Failure, User>> updateEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AppStrings.userIsNull;

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(email);
      await _auth.currentUser!.reload();
      return Either.right(_auth.currentUser!);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, User>> linkEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AppStrings.userIsNull;

      final credential = await user.linkWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: password,
        ),
      );

      await credential.user!.reload();
      if (!(credential.user!.emailVerified)) {
        await credential.user!.sendEmailVerification();
      }
      return Either.right(credential.user!);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Stream<User?> userChanges() => _auth.userChanges();

  @override
  Future<Either<Failure, UserCredential>> reauthenticateWithCredential({
    required String email,
    required String password,
  }) async {
    try {
      return Either.right(await _auth.signInWithEmailAndPassword(
          email: email, password: password));
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }
}
