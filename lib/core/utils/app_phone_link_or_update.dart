import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/dependency_injection.dart';
import '../logic/phone_link_or_update/phone_link_or_update_cubit.dart';
import '../widgets/phone_bottom_sheet/phone_bottom_sheet.dart';

abstract class AppPhoneLinkOrUpdate {
  static bool _hasShownSheet = false;

  static Future<void> checkAndShowPhoneBottomSheetForLink({
    required BuildContext context,
  }) async {
    final currentUser = getIt<FirebaseAuth>().currentUser;

    if (((currentUser?.phoneNumber?.isEmpty ?? true) &&
        context.mounted &&
        !_hasShownSheet)) {
      _hasShownSheet = true;
      await _showBottomSheet(context, true);
    }
  }

  static Future<void> showPhoneBottomSheetForUpdate({
    required BuildContext context,
  }) async {
    _hasShownSheet = true;
    await _showBottomSheet(context, false);
  }

  static Future<void> _showBottomSheet(
      BuildContext context, bool isLinking) async {
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return BlocProvider(
            create: (context) => PhoneLinkOrUpdateCubit(
              phoneRepository: getIt(),
              userRepository: getIt(),
              authCubit: context.read<AuthCubit>(),
            ),
            child: PhoneBottomSheet(isLinking: isLinking),
          );
        },
      );
    } finally {
      _hasShownSheet = false;
    }
  }
}
