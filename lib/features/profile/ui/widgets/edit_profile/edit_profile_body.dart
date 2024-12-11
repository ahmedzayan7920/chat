import 'package:flutter/material.dart';

import '../../../../../core/widgets/spaces.dart';
import 'edit_profile_form.dart';
import 'edit_profile_image.dart';

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            EditProfileImage(),
            VerticalSpace(height: 16),
            EditProfileForm(),
          ],
        ),
      ),
    );
  }
}
