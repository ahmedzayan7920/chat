import 'package:chat/core/models/user_model.dart';

sealed class EmailSettingsState {
  const EmailSettingsState();
}

class EmailSettingsInitialState extends EmailSettingsState {
  const EmailSettingsInitialState();
}

class EmailSettingsLoadingState extends EmailSettingsState {
  const EmailSettingsLoadingState();
}

class EmailSettingsFailureState extends EmailSettingsState {
  final String message;
  const EmailSettingsFailureState({required this.message});
}

class EmailSettingsVerificationWaitingState extends EmailSettingsState {
  const EmailSettingsVerificationWaitingState();
}

class EmailSettingsLogoutState extends EmailSettingsState {
  const EmailSettingsLogoutState();
}

class EmailSettingsSuccessState extends EmailSettingsState {
  final UserModel updatedUser;
  const EmailSettingsSuccessState({required this.updatedUser});
}
