import '../../data_sources/user/user_data_source.dart';
import '../../models/either.dart';
import '../../models/failure.dart';
import '../../models/user_model.dart';
import 'user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final UserDataSource _userDataSource;

  FirebaseUserRepository({
    required UserDataSource userDataSource,
  }) : _userDataSource = userDataSource;
  
  @override
  Future<Either<Failure, UserModel>> fetchOrSaveUser(UserModel userModel) async {
    return _userDataSource.fetchOrSaveUser(userModel);
  }
  
  @override
  Future<Either<Failure, UserModel>> fetchUserFromDatabase(String userId) async {
    return _userDataSource.fetchUserFromDatabase(userId);
  }
  
  @override
  Future<Either<Failure, UserModel>> storeUserToDatabase(UserModel user) async {
    return _userDataSource.storeUserToDatabase(user);
  }

  @override
  Future<Either<Failure, List<UserModel>>> fetchAllUsers() async {
    return _userDataSource.fetchAllUsers();
  }
}
