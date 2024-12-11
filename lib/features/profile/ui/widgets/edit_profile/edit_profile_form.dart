import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/models/user_model.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_validator.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/spaces.dart';
import '../../../logic/profile_cubit.dart';
import 'edit_profile_button.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final nameController = TextEditingController();
  final statusController = TextEditingController();
  late UserModel user;
  final _formKey = GlobalKey<FormState>();

  bool _shouldValidate = false;

  bool _validateForm() {
    setState(() {
      _shouldValidate = true;
    });
    return _formKey.currentState?.validate() == true;
  }

  @override
  void initState() {
    user = context.read<ProfileCubit>().currentUser;
    nameController.text = user.name;
    statusController.text = user.status;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode:
          _shouldValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      child: Column(
        children: [
          CustomTextFormField(
            label: AppStrings.nameHint,
            prefixIcon: Icons.person_outline,
            controller: nameController,
            validator: AppValidator.validateName,
          ),
          const VerticalSpace(height: 16),
          CustomTextFormField(
            label: AppStrings.statusHint,
            prefixIcon: Icons.text_fields_outlined,
            controller: statusController,
            validator: (value) =>
                AppValidator.validateField(value, AppStrings.statusHint),
          ),
          const VerticalSpace(height: 16),
          EditProfileButton(
            nameController: nameController,
            statusController: statusController,
            validateForm: _validateForm,
          ),
        ],
      ),
    );
  }
}
