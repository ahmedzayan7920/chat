import 'package:firebase_auth/firebase_auth.dart';

sealed class PhoneLinkOrUpdateState {
  const PhoneLinkOrUpdateState();
}

final class PhoneLinkOrUpdateInitialState extends PhoneLinkOrUpdateState {
  const PhoneLinkOrUpdateInitialState();
}

final class PhoneLinkOrUpdateLoadingState extends PhoneLinkOrUpdateState {
  const PhoneLinkOrUpdateLoadingState();
}

final class PhoneLinkOrUpdateFailureState extends PhoneLinkOrUpdateState {
  final String message;
  const PhoneLinkOrUpdateFailureState({required this.message});
}

final class PhoneLinkOrUpdateOtpFailureState extends PhoneLinkOrUpdateState {
  final String message;
  final String verificationId;
  const PhoneLinkOrUpdateOtpFailureState({
    required this.message,
    required this.verificationId,
  });
}

final class PhoneLinkOrUpdateOtpSentState extends PhoneLinkOrUpdateState {
  final String verificationId;
  const PhoneLinkOrUpdateOtpSentState({required this.verificationId});
}

final class PhoneLinkOrUpdateOtpVerificationInProgressState extends PhoneLinkOrUpdateState {
  const PhoneLinkOrUpdateOtpVerificationInProgressState();
}

final class PhoneLinkOrUpdateOtpSuccessState extends PhoneLinkOrUpdateState {
  const PhoneLinkOrUpdateOtpSuccessState({required this.user});
  final User user;
}

final class PhoneLinkOrUpdateSuccessState extends PhoneLinkOrUpdateState {
  const PhoneLinkOrUpdateSuccessState();
}
