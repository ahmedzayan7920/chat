import 'package:flutter/material.dart';

import '../../logic/phone_link/phone_link_state.dart';
import '../../utils/app_strings.dart';
import '../spaces.dart';

class PhoneLinkBottomSheetFailureText extends StatelessWidget {
  const PhoneLinkBottomSheetFailureText({
    super.key,
    required this.state,
  });

  final PhoneLinkState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VerticalSpace(height: 16),
        Text(
          state is PhoneLinkFailureState
              ? (state as PhoneLinkFailureState).message
              : state is PhoneLinkOtpFailureState
                  ? (state as PhoneLinkOtpFailureState).message
                  : AppStrings.emptyString,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      ],
    );
  }
}