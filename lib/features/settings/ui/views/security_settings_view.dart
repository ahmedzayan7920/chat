import 'package:chat/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            onTap: () {},
            leading: Icon(Icons.email_outlined),
            title: Text(currentUser.email),
          ),
          ListTile(
            onTap: () {},
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
