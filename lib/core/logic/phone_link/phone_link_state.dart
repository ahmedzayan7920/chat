import 'package:firebase_auth/firebase_auth.dart';

sealed class PhoneLinkState {
  const PhoneLinkState();
}

final class PhoneLinkInitialState extends PhoneLinkState {
  const PhoneLinkInitialState();
}

final class PhoneLinkLoadingState extends PhoneLinkState {
  const PhoneLinkLoadingState();
}

final class PhoneLinkFailureState extends PhoneLinkState {
  final String message;
  const PhoneLinkFailureState({required this.message});
}

final class PhoneLinkOtpFailureState extends PhoneLinkState {
  final String message;
  final String verificationId;
  const PhoneLinkOtpFailureState({
    required this.message,
    required this.verificationId,
  });
}

final class PhoneLinkOtpSentState extends PhoneLinkState {
  final String verificationId;
  const PhoneLinkOtpSentState({required this.verificationId});
}

final class PhoneLinkOtpVerificationInProgressState extends PhoneLinkState {
  const PhoneLinkOtpVerificationInProgressState();
}

final class PhoneLinkOtpSuccessState extends PhoneLinkState {
  const PhoneLinkOtpSuccessState({required this.user});
  final User user;
}

final class PhoneLinkSuccessState extends PhoneLinkState {
  const PhoneLinkSuccessState();
}
