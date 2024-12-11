import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import 'profile_cubit.dart';

mixin ProfileCubitRegistration {
  static int _referenceCount = 0;

  void registerProfileCubit(BuildContext context) {
    try {
      if (_referenceCount == 0) {
        if (getIt.isRegistered<ProfileCubit>()) {
          unregisterProfileCubit();
        }
        getIt.registerLazySingleton<ProfileCubit>(
          () => ProfileCubit(
            userRepository: getIt(),
            authCubit: context.read<AuthCubit>(),
            storageRepository: getIt(),
          ),
        );
      }
      _referenceCount++;
    } catch (e) {
      debugPrint('Error registering ProfileCubit: $e');
      rethrow;
    }
  }

  void unregisterProfileCubit() {
    try {
      _referenceCount--;
      if (_referenceCount == 0 && getIt.isRegistered<ProfileCubit>()) {
        final cubit = getIt<ProfileCubit>();
        cubit.close();
        getIt.unregister<ProfileCubit>();
      }
    } catch (e) {
      debugPrint('Error unregistering ProfileCubit: $e');
      rethrow;
    }
  }
}
