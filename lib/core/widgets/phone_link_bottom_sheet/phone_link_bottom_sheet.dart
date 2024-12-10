import 'package:chat/core/logic/phone_link/phone_link_cubit.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/phone_link/phone_link_state.dart';
import '../spaces.dart';
import 'phone_link_bottom_sheet_body.dart';
import 'phone_link_bottom_sheet_header.dart';

class PhoneLinkBottomSheet extends StatefulWidget {
  const PhoneLinkBottomSheet({super.key});

  @override
  State<PhoneLinkBottomSheet> createState() => _PhoneLinkBottomSheetState();
}

class _PhoneLinkBottomSheetState extends State<PhoneLinkBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhoneLinkCubit, PhoneLinkState>(
      listener: (context, state) async {
        if (state is PhoneLinkSuccessState) {
          UserModel userModel = context.read<AuthCubit>().currentUser!.copyWith(
                phoneNumber: state.user.phoneNumber,
              );
          await context.read<AuthCubit>().updateUser(userModel);
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
              PhoneLinkBottomSheetHeader(),
              VerticalSpace(height: 16),
              PhoneLinkBottomSheetBody(state: state),
            ],
          ),
        );
      },
    );
  }
}
