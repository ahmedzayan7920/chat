import 'package:chat/core/repos/phone/phone_repository.dart';
import 'package:chat/core/repos/user/user_repository.dart';
import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import 'phone_link_state.dart';

class PhoneLinkCubit extends Cubit<PhoneLinkState> {
  final PhoneRepository _phoneRepository;
  final UserRepository _userRepository;
  final AuthCubit _authCubit ;

  PhoneLinkCubit({
    required PhoneRepository phoneRepository,
    required UserRepository userRepository,
    required AuthCubit authCubit,
  })  : _phoneRepository = phoneRepository,
        _userRepository = userRepository,
        _authCubit = authCubit,
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
            emit(PhoneLinkOtpSuccessState(user: user));
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
        emit(PhoneLinkOtpSuccessState(user: user));
      },
    );
  }

  Future updateUser(UserModel userModel) async {
    final updateUserResult =
        await _userRepository.updateUserToDatabase(userModel);

    updateUserResult.fold(
      (failure) => emit(PhoneLinkFailureState(message: failure.message)),
      (userModel) {
        _authCubit.syncUserData(userModel);
        emit(PhoneLinkSuccessState());
      },
    );
  }
}
