import 'package:flutter/material.dart';

import '../../../../core/models/user_model.dart';
import 'users_view_item.dart';

class UsersViewSuccess extends StatelessWidget {
  const UsersViewSuccess({
    super.key,
    required this.users,
  });
  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UsersViewItem(user: user);
      },
    );
  }
}
