import 'package:flutter/material.dart';

import '../../logic/phone_link_or_update/phone_link_or_update_state.dart';
import '../../utils/app_strings.dart';
import '../spaces.dart';

class PhoneBottomSheetFailureText extends StatelessWidget {
  const PhoneBottomSheetFailureText({
    super.key,
    required this.state,
  });

  final PhoneLinkOrUpdateState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpace(height: 16),
        Text(
          state is PhoneLinkOrUpdateFailureState
              ? (state as PhoneLinkOrUpdateFailureState).message
              : state is PhoneLinkOrUpdateOtpFailureState
                  ? (state as PhoneLinkOrUpdateOtpFailureState).message
                  : AppStrings.emptyString,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      ],
    );
  }
}
