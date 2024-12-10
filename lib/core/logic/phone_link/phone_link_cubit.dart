import 'package:chat/core/repos/phone/phone_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'phone_link_state.dart';

class PhoneLinkCubit extends Cubit<PhoneLinkState> {
  final PhoneRepository _phoneRepository;

  PhoneLinkCubit({
    required PhoneRepository phoneRepository,
  })  : _phoneRepository = phoneRepository,
        super(const PhoneLinkInitialState());

  emitInitial() {
    emit(const PhoneLinkInitialState());
  }

  Future<void> linkPhoneNumber(String phoneNumber) async {
    emit(const PhoneLinkLoadingState());

    final result = await _phoneRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      isLinking: true,
    );

    result.fold(
      (failure) => emit(PhoneLinkFailureState(message: failure.message)),
      (verificationResult) {
        verificationResult.fold(
          (verificationId) =>
              emit(PhoneLinkOtpSentState(verificationId: verificationId)),
          (user) async {
            emit(PhoneLinkSuccessState(user: user));
          },
        );
      },
    );
  }

  Future<void> verifyOtpCode({
    required String verificationId,
    required String otp,
  }) async {
    emit(const PhoneLinkOtpVerificationInProgressState());

    final result = await _phoneRepository.verifyOtpCode(
      verificationId: verificationId,
      otp: otp,
      isLinking: true,
    );

    result.fold(
      (failure) => emit(PhoneLinkOtpFailureState(
        message: failure.message,
        verificationId: verificationId,
      )),
      (user) async {
        emit(PhoneLinkSuccessState(user: user));
      },
    );
  }
}
