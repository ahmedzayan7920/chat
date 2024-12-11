import 'package:chat/core/repos/phone/phone_repository.dart';
import 'package:chat/core/repos/user/user_repository.dart';
import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../enums/phone_auth_type.dart';
import '../../models/user_model.dart';
import 'phone_link_or_update_state.dart';

class PhoneLinkOrUpdateCubit extends Cubit<PhoneLinkOrUpdateState> {
  final PhoneRepository _phoneRepository;
  final UserRepository _userRepository;
  final AuthCubit _authCubit;

  PhoneLinkOrUpdateCubit({
    required PhoneRepository phoneRepository,
    required UserRepository userRepository,
    required AuthCubit authCubit,
  })  : _phoneRepository = phoneRepository,
        _userRepository = userRepository,
        _authCubit = authCubit,
        super(const PhoneLinkOrUpdateInitialState());

  emitInitial() {
    emit(const PhoneLinkOrUpdateInitialState());
  }

  Future<void> linkPhoneNumber({
    required String phoneNumber,
    required PhoneAuthType phoneAuthType,
  }) async {
    emit(const PhoneLinkOrUpdateLoadingState());

    final result = await _phoneRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      phoneAuthType: phoneAuthType,
    );

    result.fold(
      (failure) => emit(PhoneLinkOrUpdateFailureState(message: failure.message)),
      (verificationResult) {
        verificationResult.fold(
          (verificationId) =>
              emit(PhoneLinkOrUpdateOtpSentState(verificationId: verificationId)),
          (user) async {
            emit(PhoneLinkOrUpdateOtpSuccessState(user: user));
          },
        );
      },
    );
  }

  Future<void> verifyOtpCode({
    required String verificationId,
    required String otp,
    required PhoneAuthType phoneAuthType,
  }) async {
    emit(const PhoneLinkOrUpdateOtpVerificationInProgressState());

    final result = await _phoneRepository.verifyOtpCode(
      verificationId: verificationId,
      otp: otp,
      phoneAuthType: phoneAuthType,
    );

    result.fold(
      (failure) => emit(PhoneLinkOrUpdateOtpFailureState(
        message: failure.message,
        verificationId: verificationId,
      )),
      (user) async {
        emit(PhoneLinkOrUpdateOtpSuccessState(user: user));
      },
    );
  }

  Future updateUser(UserModel userModel) async {
    final updateUserResult =
        await _userRepository.updateUserToDatabase(userModel);

    updateUserResult.fold(
      (failure) => emit(PhoneLinkOrUpdateFailureState(message: failure.message)),
      (userModel) {
        _authCubit.syncUserData(userModel);
        emit(PhoneLinkOrUpdateSuccessState());
      },
    );
  }
}
