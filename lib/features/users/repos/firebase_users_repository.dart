import '../data_sources/user_data_source.dart';
import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import '../../../core/models/user_model.dart';

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
