import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_pinput.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_state.dart';
import '../../../../core/widgets/spaces.dart';

import '../widgets/phone_otp/verify_otp_button.dart';

class PhoneOtpView extends StatefulWidget {
  const PhoneOtpView({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<PhoneOtpView> createState() => _PhoneOtpViewState();
}

class _PhoneOtpViewState extends State<PhoneOtpView> {
  String otp = AppStrings.emptyString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.verifyOtp)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              bool isLoading = state is OtpVerificationInProgressState;
              bool isOtpValid = otp.trim().length == 6;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomPinput(
                    isEnabled: !isLoading,
                    onChanged: (value) {
                      setState(() {
                        otp = value;
                      });
                    },
                    onCompleted: (value) {
                      if (value.trim().length == 6) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                  const VerticalSpace(height: 16),
                  VerifyOtpButton(
                    isLoading: isLoading,
                    isOtpValid: isOtpValid,
                    onPressed: () {
                      context.read<AuthCubit>().verifyOtpCode(
                            verificationId: widget.verificationId,
                            otp: otp.trim(),
                          );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
