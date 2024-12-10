import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/phone_link/phone_link_cubit.dart';
import '../../logic/phone_link/phone_link_state.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_strings.dart';
import '../custom_elevated_button.dart';
import '../custom_phone_number_field.dart';
import '../custom_pinput.dart';
import '../spaces.dart';
import 'phone_link_bottom_sheet_failure_text.dart';

class PhoneLinkBottomSheetBody extends StatefulWidget {
  const PhoneLinkBottomSheetBody({
    super.key,
    required this.state,
  });
  final PhoneLinkState state;

  @override
  State<PhoneLinkBottomSheetBody> createState() =>
      _PhoneLinkBottomSheetBodyState();
}

class _PhoneLinkBottomSheetBodyState extends State<PhoneLinkBottomSheetBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNumber = AppStrings.emptyString;
  String countryCode = AppStrings.emptyString;
  String otp = AppStrings.emptyString;
  bool get isPhoneNumberValid =>
      phoneNumber.isNotEmpty &&
      countryCode.isNotEmpty &&
      _formKey.currentState!.validate();

  bool get isOtpValid => otp.trim().length == 6;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.state is PhoneLinkOtpSentState ||
                widget.state is PhoneLinkOtpVerificationInProgressState ||
                widget.state is PhoneLinkOtpFailureState ||
                widget.state is PhoneLinkSuccessState)
              CustomPinput(
                isEnabled: true,
                onChanged: onOtpChanged,
                onCompleted: onOtpCompleted,
              )
            else
              CustomPhoneNumberField(
                initialCountryCode: AppConstants.initialCountryCode,
                onPhoneNumberChanged: onPhoneNumberChanged,
              ),
            VerticalSpace(height: 16),
            if (widget.state is PhoneLinkOtpSentState ||
                widget.state is PhoneLinkOtpVerificationInProgressState ||
                widget.state is PhoneLinkOtpFailureState ||
                widget.state is PhoneLinkSuccessState)
              CustomElevatedButton(
                text: AppStrings.verifyOtp,
                isLoading:
                    (widget.state is PhoneLinkOtpVerificationInProgressState ||
                        widget.state is PhoneLinkSuccessState),
                onPressed: isOtpValid ? otpButtonOnPressed : null,
              )
            else
              CustomElevatedButton(
                text: AppStrings.verifyPhoneNumber,
                isLoading: widget.state is PhoneLinkLoadingState,
                onPressed:
                    isPhoneNumberValid ? verifyPhoneNumberOnPressed : null,
              ),
            if (widget.state is PhoneLinkFailureState ||
                widget.state is PhoneLinkOtpFailureState)
              PhoneLinkBottomSheetFailureText(state: widget.state),
          ],
        ),
      ),
    );
  }

  onOtpChanged(value) {
    setState(() {
      otp = value;
    });
  }

  onOtpCompleted(value) {
    if (value.trim().length == 6) {
      FocusScope.of(context).unfocus();
    }
  }

  onPhoneNumberChanged(number, code) {
    setState(() {
      phoneNumber = number;
      countryCode = code;
    });
  }

  otpButtonOnPressed() {
    FocusScope.of(context).unfocus();
    context.read<PhoneLinkCubit>().verifyOtpCode(
          verificationId: widget.state is PhoneLinkOtpSentState
              ? ((widget.state as PhoneLinkOtpSentState).verificationId)
              : ((widget.state as PhoneLinkOtpFailureState).verificationId),
          otp: otp.trim(),
        );
  }

  verifyPhoneNumberOnPressed() {
    FocusScope.of(context).unfocus();
    context.read<PhoneLinkCubit>().linkPhoneNumber(
          '$countryCode$phoneNumber',
        );
    phoneNumber = AppStrings.emptyString;
    countryCode = AppStrings.emptyString;
  }
}
