import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../enums/phone_auth_type.dart';
import '../../logic/phone_link_or_update/phone_link_or_update_cubit.dart';
import '../../logic/phone_link_or_update/phone_link_or_update_state.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_strings.dart';
import '../custom_elevated_button.dart';
import '../custom_phone_number_field.dart';
import '../custom_pinput.dart';
import '../spaces.dart';
import 'phone_bottom_sheet_failure_text.dart';

class PhoneBottomSheetBody extends StatefulWidget {
  const PhoneBottomSheetBody({
    super.key,
    required this.state,
    required this.isLinking,
  });
  final PhoneLinkOrUpdateState state;
  final bool isLinking;

  @override
  State<PhoneBottomSheetBody> createState() => _PhoneBottomSheetBodyState();
}

class _PhoneBottomSheetBodyState extends State<PhoneBottomSheetBody> {
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
            if (widget.state is PhoneLinkOrUpdateOtpSentState ||
                widget.state is PhoneLinkOrUpdateOtpVerificationInProgressState ||
                widget.state is PhoneLinkOrUpdateOtpFailureState ||
                widget.state is PhoneLinkOrUpdateOtpSuccessState)
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
            if (widget.state is PhoneLinkOrUpdateOtpSentState ||
                widget.state is PhoneLinkOrUpdateOtpVerificationInProgressState ||
                widget.state is PhoneLinkOrUpdateOtpFailureState ||
                widget.state is PhoneLinkOrUpdateOtpSuccessState)
              CustomElevatedButton(
                text: AppStrings.verifyOtp,
                isLoading:
                    (widget.state is PhoneLinkOrUpdateOtpVerificationInProgressState ||
                        widget.state is PhoneLinkOrUpdateOtpSuccessState),
                onPressed: isOtpValid ? otpButtonOnPressed : null,
              )
            else
              CustomElevatedButton(
                text: AppStrings.verifyPhoneNumber,
                isLoading: widget.state is PhoneLinkOrUpdateLoadingState,
                onPressed:
                    isPhoneNumberValid ? verifyPhoneNumberOnPressed : null,
              ),
            if (widget.state is PhoneLinkOrUpdateFailureState ||
                widget.state is PhoneLinkOrUpdateOtpFailureState)
              PhoneBottomSheetFailureText(state: widget.state),
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
    context.read<PhoneLinkOrUpdateCubit>().verifyOtpCode(
          verificationId: widget.state is PhoneLinkOrUpdateOtpSentState
              ? ((widget.state as PhoneLinkOrUpdateOtpSentState).verificationId)
              : ((widget.state as PhoneLinkOrUpdateOtpFailureState).verificationId),
          otp: otp.trim(),
          phoneAuthType:
              widget.isLinking ? PhoneAuthType.link : PhoneAuthType.update,
        );
  }

  verifyPhoneNumberOnPressed() {
    FocusScope.of(context).unfocus();
    context.read<PhoneLinkOrUpdateCubit>().linkPhoneNumber(
          phoneNumber: '$countryCode$phoneNumber',
          phoneAuthType:
              widget.isLinking ? PhoneAuthType.link : PhoneAuthType.update,
        );
    phoneNumber = AppStrings.emptyString;
    countryCode = AppStrings.emptyString;
  }
}
