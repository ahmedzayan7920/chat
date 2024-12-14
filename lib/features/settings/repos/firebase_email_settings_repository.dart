import 'package:chat/core/models/either.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/failure.dart';
import '../data_sources/email_settings_data_source.dart';
import 'email_settings_repository.dart';

class FirebaseEmailSettingsRepository implements EmailSettingsRepository {
  final EmailSettingsDataSource _emailSettingsDataSource;

  FirebaseEmailSettingsRepository({
    required EmailSettingsDataSource emailSettingsDataSource,
  }) : _emailSettingsDataSource = emailSettingsDataSource;

  @override
  Future<Either<Failure, User>> updateEmail({
    required String email,
    required String password,
  }) async {
    return _emailSettingsDataSource.updateEmail(
        email: email, password: password);
  }

  @override
  Future<Either<Failure, User>> linkEmail({
    required String email,
    required String password,
  }) async {
    return _emailSettingsDataSource.linkEmail(email: email, password: password);
  }

  @override
  Stream<User?> userChanges() => _emailSettingsDataSource.userChanges();

  @override
  Future<Either<Failure, UserCredential>> reauthenticateWithCredential({
    required String email,
    required String password,
  }) async {
    return _emailSettingsDataSource.reauthenticateWithCredential(
      email: email,
      password: password,
    );
  }
}
