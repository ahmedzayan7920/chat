import 'package:chat/core/utils/app_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/either.dart';
import '../../../core/models/failure.dart';
import '../../../core/models/user_model.dart';
import '../utils/firebase_constants.dart';
import 'user_data_source.dart';

class FirebaseUserDataSource implements UserDataSource {
  final FirebaseFirestore _firestore;

  FirebaseUserDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<Either<Failure, UserModel>> storeUserToDatabase(UserModel user) async {
    try {
      await _firestore
          .collection(FirebaseConstants.users)
          .doc(user.id)
          .set(user.toJson());
      return Either.right(user);
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> fetchUserFromDatabase(
      String userId) async {
    try {
      final userDoc = await _firestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return Either.right(UserModel.fromJson(userDoc.data()!));
      } else {
        return Either.left(const Failure(AppStrings.userNotFound));
      }
    } catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> fetchOrSaveUser(User user) async {
    final fetchResult = await fetchUserFromDatabase(user.uid);

    return fetchResult.fold(
      (failure) async {
        UserModel newUser = UserModel(
          id: user.uid,
          name: user.displayName ?? AppStrings.emptyString,
          email: user.email ?? AppStrings.emptyString,
          profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
        );

        final saveResult = await storeUserToDatabase(newUser);
        return saveResult.fold(
          (saveFailure) => Either.left(saveFailure),
          (_) => Either.right(newUser),
        );
      },
      (existingUser) => Either.right(existingUser),
    );
  }
}
