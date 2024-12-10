import '../../../../core/models/either.dart';
import '../../../../core/models/failure.dart';
import '../../../../core/models/user_model.dart';

abstract class UserDataSource {
  Future<Either<Failure, UserModel>> storeUserToDatabase(UserModel user);
  
  Future<Either<Failure, UserModel>> updateUserToDatabase(UserModel user);

  Future<Either<Failure, UserModel>> fetchUserFromDatabase(String userId);

  Future<Either<Failure, UserModel>> fetchOrSaveUser(UserModel userModel);

  Future<Either<Failure, List<UserModel>>> fetchAllUsers();
}
