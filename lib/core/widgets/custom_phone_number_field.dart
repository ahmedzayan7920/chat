import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';

import '../utils/app_strings.dart';

class CustomPhoneNumberField extends StatelessWidget {
  final String initialCountryCode;
  final Function(String number, String countryCode) onPhoneNumberChanged;

  const CustomPhoneNumberField({
    super.key,
    required this.initialCountryCode,
    required this.onPhoneNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      autofocus: true,
      initialCountryCode: initialCountryCode,
      decoration: const InputDecoration(
        labelText: AppStrings.phoneNumber,
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      onChanged: (phone) {
        onPhoneNumberChanged(phone.number, phone.countryCode);
      },
      onCountryChanged: (phone) {
        onPhoneNumberChanged(AppStrings.emptyString, phone.code);
      },
    );
  }
}
