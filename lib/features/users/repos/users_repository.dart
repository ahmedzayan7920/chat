import 'package:chat/core/models/either.dart';
import 'package:chat/core/models/failure.dart';

import '../../../../core/models/user_model.dart';

abstract class UsersRepository {
  Future<Either<Failure, List<UserModel>>> fetchAllUsers();
}
