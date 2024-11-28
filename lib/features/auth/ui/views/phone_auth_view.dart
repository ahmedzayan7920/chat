import 'package:chat/core/utils/app_strings.dart';
import 'package:chat/core/widgets/custom_phone_number_field.dart';
import 'package:chat/core/widgets/spaces.dart';
import 'package:chat/features/auth/ui/widgets/phone_auth/verify_phone_number_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_constants.dart';
import '../../logic/auth_cubit.dart';

class PhoneAuthView extends StatefulWidget {
  const PhoneAuthView({super.key});

  @override
  State<PhoneAuthView> createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNumber = AppStrings.emptyString;
  String countryCode = AppStrings.emptyString;

  bool get isPhoneNumberValid =>
      phoneNumber.isNotEmpty &&
      countryCode.isNotEmpty &&
      _formKey.currentState!.validate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.verifyPhoneNumber)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPhoneNumberField(
                  initialCountryCode: AppConstants.initialCountryCode,
                  onPhoneNumberChanged: (number, code) {
                    setState(() {
                      phoneNumber = number;
                      countryCode = code;
                    });
                  },
                ),
                const VerticalSpace(height: 16),
                VerifyPhoneNumberButton(
                  isPhoneNumberValid: isPhoneNumberValid,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context.read<AuthCubit>().verifyPhoneNumber(
                          '$countryCode$phoneNumber',
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
