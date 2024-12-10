import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/dependency_injection.dart';
import '../logic/phone_link/phone_link_cubit.dart';
import '../widgets/phone_link_bottom_sheet/phone_link_bottom_sheet.dart';

abstract class AppPhoneLink {
  static bool _hasShownSheet = false;

  static Future<void> checkAndShowPhoneLinkBottomSheet(
    BuildContext context, {
    required bool mounted,
  }) async {
    final currentUser = getIt<FirebaseAuth>().currentUser;

    if ((currentUser?.phoneNumber?.isEmpty ?? true) &&
        mounted &&
        !_hasShownSheet) {
      _hasShownSheet = true;

      try {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) {
            return BlocProvider(
              create: (context) => PhoneLinkCubit(
                phoneRepository: getIt(),
                userRepository: getIt(),
                authCubit: context.read<AuthCubit>(),
              ),
              child: const PhoneLinkBottomSheet(),
            );
          },
        );
      } finally {
        _hasShownSheet = false;
      }
    }
  }
}
