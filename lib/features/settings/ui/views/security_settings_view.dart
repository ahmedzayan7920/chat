import 'package:chat/core/models/user_model.dart';
import 'package:chat/core/utils/app_phone_link_or_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_routes.dart';
import '../../../auth/logic/auth_cubit.dart';

class SecuritySettingsView extends StatelessWidget {
  const SecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.watch<AuthCubit>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Security Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.emailSettings,
                arguments: currentUser.email,
              );
            },
            leading: Icon(Icons.email_outlined),
            title: Text(
              currentUser.email.isNotEmpty
                  ? currentUser.email
                  : "Add Email Address",
            ),
          ),
          ListTile(
            onTap: () {
              currentUser.phoneNumber.isNotEmpty
                  ? AppPhoneLinkOrUpdate.showPhoneBottomSheetForUpdate(
                      context: context)
                  : AppPhoneLinkOrUpdate.checkAndShowPhoneBottomSheetForLink(
                      context: context);
            },
            leading: Icon(Icons.phone_outlined),
            title: Text(
              currentUser.phoneNumber.isNotEmpty
                  ? currentUser.phoneNumber
                  : "Add Phone Number",
            ),
          ),
        ],
      ),
    );
  }
}
