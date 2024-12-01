import 'package:chat/features/users/data_sources/user_data_source.dart';
import 'package:chat/core/models/either.dart';
import 'package:chat/core/models/failure.dart';
import 'package:chat/core/models/user_model.dart';

import 'users_repository.dart';

class FirebaseUsersRepository implements UsersRepository {
  final UserDataSource _userDataSource;

  FirebaseUsersRepository({
    required UserDataSource userDataSource,
  }) : _userDataSource = userDataSource;

  @override
  Future<Either<Failure, List<UserModel>>> fetchAllUsers() async {
    return _userDataSource.fetchAllUsers();
  }
}
