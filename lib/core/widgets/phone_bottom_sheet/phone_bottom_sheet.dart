import 'package:chat/core/logic/phone_link_or_update/phone_link_or_update_cubit.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/phone_link_or_update/phone_link_or_update_state.dart';
import '../spaces.dart';
import 'phone_bottom_sheet_body.dart';
import 'phone_bottom_sheet_header.dart';

class PhoneBottomSheet extends StatefulWidget {
  const PhoneBottomSheet({super.key, required this.isLinking});
  final bool isLinking;

  @override
  State<PhoneBottomSheet> createState() => _PhoneBottomSheetState();
}

class _PhoneBottomSheetState extends State<PhoneBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneLinkOrUpdateCubit, PhoneLinkOrUpdateState>(
      listener: (context, state) {
        if (state is PhoneLinkOrUpdateOtpSuccessState) {
          UserModel userModel = context.read<AuthCubit>().currentUser!.copyWith(
                phoneNumber: state.user.phoneNumber,
              );
          context.read<PhoneLinkOrUpdateCubit>().updateUser(userModel);
        } else if (state is PhoneLinkOrUpdateSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PhoneBottomSheetHeader(isLinking: widget.isLinking),
              VerticalSpace(height: 16),
              PhoneBottomSheetBody(state: state, isLinking: widget.isLinking),
            ],
          ),
        );
      },
    );
  }
}
