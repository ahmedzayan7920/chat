import 'dart:async';

import 'package:chat/core/repos/user/user_repository.dart';
import 'package:chat/features/notification/repos/notification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/phone_auth_type.dart';
import '../../../core/models/user_model.dart';
import '../../../core/utils/app_strings.dart';
import '../repos/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final NotificationRepository _notificationRepository;

  AuthCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required NotificationRepository notificationRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _notificationRepository = notificationRepository,
        super(const AuthInitialState());

  UserModel? get currentUser {
    final currentState = state;
    if (currentState is AuthenticatedState) {
      return currentState.user;
    }
    return null;
  }

  void syncUserData(UserModel updatedUser) {
    final currentState = state;
    if (currentState is AuthenticatedState) {
      emit(AuthenticatedState(user: updatedUser));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(const UnauthenticatedState()),
      (user) async {
        final result = await _userRepository.fetchUserFromDatabase(user.uid);
        result.fold(
          (failure) => emit(const UnauthenticatedState()),
          (userModel) => emit(AuthenticatedState(user: userModel)),
        );
      },
    );
  }

  updateUserEmail() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(const UnauthenticatedState()),
      (user) async {
        if (user.email != null &&
            currentUser != null &&
            currentUser!.email != user.email) {
          final updatedUser = currentUser!.copyWith(
            email: user.email,
          );
          final result =
              await _userRepository.updateUserToDatabase(updatedUser);
          result.fold(
            (failure) => emit(const UnauthenticatedState()),
            (userModel) => emit(AuthenticatedState(user: userModel)),
          );
        }
      },
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthLoadingState());

    final result = await _authRepository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
    final token = await _notificationRepository.getToken();
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) async {
        final userModel = UserModel.newUser(
          id: user.uid,
          name: name,
          email: email,
          phoneNumber: user.phoneNumber ?? AppStrings.emptyString,
          fcmTokens: [token ?? AppStrings.emptyString],
        );
        final saveResult = await _userRepository.storeUserToDatabase(userModel);
        saveResult.fold(
          (failure) => emit(AuthErrorState(message: failure.message)),
          (_) => emit(AuthenticatedState(user: userModel)),
        );
      },
    );
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoadingState());

    final result = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) async {
        final fetchUserResult =
            await _userRepository.fetchUserFromDatabase(user.uid);
        fetchUserResult.fold(
          (failure) => emit(AuthErrorState(message: failure.message)),
          (userModel) => emit(AuthenticatedState(user: userModel)),
        );
      },
    );
  }

  Future<void> loginWithGoogle() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.loginWithGoogle();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) async {
    final token = await _notificationRepository.getToken();
        final userModel = UserModel.newUser(
          id: user.uid,
          name: user.displayName ?? AppStrings.emptyString,
          email: user.email ?? AppStrings.emptyString,
          phoneNumber: user.phoneNumber ?? AppStrings.emptyString,
          profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
          fcmTokens: [token ?? AppStrings.emptyString],
        );
        final fetchOrSaveResult =
            await _userRepository.fetchOrSaveUser(userModel);
        fetchOrSaveResult.fold(
          (failure) => emit(AuthErrorState(message: failure.message)),
          (userModel) => emit(AuthenticatedState(user: userModel)),
        );
      },
    );
  }

  Future<void> loginWithFacebook() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.loginWithFacebook();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) async {
    final token = await _notificationRepository.getToken();
        final userModel = UserModel.newUser(
          id: user.uid,
          name: user.displayName ?? AppStrings.emptyString,
          email: user.email ?? AppStrings.emptyString,
          phoneNumber: user.phoneNumber ?? AppStrings.emptyString,
          profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
          fcmTokens: [token ?? AppStrings.emptyString],
        );
        final fetchOrSaveResult =
            await _userRepository.fetchOrSaveUser(userModel);
        fetchOrSaveResult.fold(
          (failure) => emit(AuthErrorState(message: failure.message)),
          (userModel) => emit(AuthenticatedState(user: userModel)),
        );
      },
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    emit(const AuthLoadingState());

    final result = await _authRepository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      phoneAuthType: PhoneAuthType.auth,
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (verificationResult) {
        verificationResult.fold(
          (verificationId) =>
              emit(OtpSentState(verificationId: verificationId)),
          (user) async {
    final token = await _notificationRepository.getToken();
            final userModel = UserModel.newUser(
              id: user.uid,
              name: user.displayName ??
                  user.phoneNumber ??
                  AppStrings.emptyString,
              email: user.email ?? AppStrings.emptyString,
              phoneNumber: user.phoneNumber ?? AppStrings.emptyString,
              profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
          fcmTokens: [token ?? AppStrings.emptyString],
            );

            final fetchOrSaveResult =
                await _userRepository.fetchOrSaveUser(userModel);

            return fetchOrSaveResult.fold(
              (failure) => emit(AuthErrorState(message: failure.message)),
              (userModel) => emit(AuthenticatedState(user: userModel)),
            );
          },
        );
      },
    );
  }

  Future<void> verifyOtpCode({
    required String verificationId,
    required String otp,
  }) async {
    emit(const OtpVerificationInProgressState());

    final result = await _authRepository.verifyOtpCode(
      verificationId: verificationId,
      otp: otp,
      phoneAuthType: PhoneAuthType.auth,
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) async {
    final token = await _notificationRepository.getToken();
        final userModel = UserModel.newUser(
          id: user.uid,
          name: user.displayName ?? user.phoneNumber ?? AppStrings.emptyString,
          email: user.email ?? AppStrings.emptyString,
          phoneNumber: user.phoneNumber ?? AppStrings.emptyString,
          profilePictureUrl: user.photoURL ?? AppStrings.emptyString,
          fcmTokens: [token ?? AppStrings.emptyString],
        );
        final fetchOrSaveResult =
            await _userRepository.fetchOrSaveUser(userModel);

        return fetchOrSaveResult.fold(
          (failure) => emit(AuthErrorState(message: failure.message)),
          (userModel) => emit(AuthenticatedState(user: userModel)),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.logout();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(const UnauthenticatedState()),
    );
  }
}
