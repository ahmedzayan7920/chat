import 'dart:io';

import 'package:chat/core/repos/storage/storage_repository.dart';
import 'package:chat/core/repos/user/user_repository.dart';
import 'package:chat/core/supabase/supabase_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/user_model.dart';
import '../../auth/logic/auth_cubit.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final AuthCubit _authCubit;

  ProfileCubit({
    required UserRepository userRepository,
    required AuthCubit authCubit,
    required StorageRepository storageRepository,
  })  : _userRepository = userRepository,
        _authCubit = authCubit,
        _storageRepository = storageRepository,
        super(ProfileInitialState());

  UserModel get currentUser => _authCubit.currentUser!;
  File? _imageFile;
  File? get imageFile => _imageFile;

  void setImageFile(File? file) {
    _imageFile = file;
    emit(ProfileInitialState());
  }

  Future<void> updateUserProfile({required UserModel userModel}) async {
    emit(ProfileLoadingState());
    if (imageFile != null) {
      final uploadResult = await _storageRepository.uploadFile(
        filePath: imageFile!.path,
        fileName: userModel.id,
        bucketName: SupabaseConstants.profilesBucket,
      );
      uploadResult.fold(
        (failure) {
          emit(ProfileFailureState(
            message: failure.message,
          ));
        },
        (url) async {
          _imageFile = null;
          userModel = userModel.copyWith(
              profilePictureUrl:
                  '$url?timestamp=${DateTime.now().millisecondsSinceEpoch}');
          _updateUserProfile(userModel);
        },
      );
    } else {
      _updateUserProfile(userModel);
    }
  }

  _updateUserProfile(UserModel userModel) async {
    final result = await _userRepository.updateUserToDatabase(userModel);
    result.fold(
      (failure) {
        emit(ProfileFailureState(
          message: failure.message,
        ));
      },
      (userModel) {
        _authCubit.syncUserData(userModel);
        emit(ProfileSuccessState());
      },
    );
  }
}
