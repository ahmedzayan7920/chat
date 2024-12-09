import '../../../../core/models/user_model.dart';
import '../../models/either.dart';
import '../../models/failure.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> storeUserToDatabase(UserModel user);

  Future<Either<Failure, UserModel>> fetchUserFromDatabase(String userId);

  Future<Either<Failure, UserModel>> fetchOrSaveUser(UserModel userModel);
  
  Future<Either<Failure, List<UserModel>>> fetchAllUsers();
}
