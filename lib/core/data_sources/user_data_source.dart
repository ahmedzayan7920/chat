import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import '../../../core/models/user_model.dart';

abstract class UserDataSource {
  Future<Either<Failure, UserModel>> storeUserToDatabase(UserModel user);

  Future<Either<Failure, UserModel>> fetchUserFromDatabase(String userId);

  Future<Either<Failure, UserModel>> fetchOrSaveUser(User user);
}
