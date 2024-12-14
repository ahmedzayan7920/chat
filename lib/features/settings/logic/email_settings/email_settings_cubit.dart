import 'dart:async';

import 'package:chat/core/repos/user/user_repository.dart';
import 'package:chat/features/auth/logic/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/email_settings_repository.dart';
import 'email_settings_state.dart';

class EmailSettingsCubit extends Cubit<EmailSettingsState> {
  final AuthCubit _authCubit;
  final EmailSettingsRepository _emailSettingsRepository;
  final UserRepository _userRepository;
  StreamSubscription? _authSubscription;

  EmailSettingsCubit({
    required AuthCubit authCubit,
    required EmailSettingsRepository emailSettingsRepository,
    required UserRepository userRepository,
  })  : _authCubit = authCubit,
        _emailSettingsRepository = emailSettingsRepository,
        _userRepository = userRepository,
        super(EmailSettingsInitialState());

  Future<void> updateEmail({
    required String email,
    required String password,
  }) async {
    emit(EmailSettingsLoadingState());

    final result = await _emailSettingsRepository.updateEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(EmailSettingsFailureState(message: failure.message)),
      (user) async {
        if (user.email == email && user.emailVerified) {
          _updateUser(email: user.email!);
        } else {
          listenToAuthChanges(email: email, password: password);
          emit(EmailSettingsVerificationWaitingState());
        }
      },
    );
  }

  Future<void> linkEmail({
    required String email,
    required String password,
  }) async {
    emit(EmailSettingsLoadingState());

    final result = await _emailSettingsRepository.linkEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(EmailSettingsFailureState(message: failure.message)),
      (user) async {
        if (user.emailVerified) {
          _updateUser(email: user.email!);
        } else {
          listenToAuthChanges(email: email, password: password);
          emit(EmailSettingsVerificationWaitingState());
        }
      },
    );
  }

  void listenToAuthChanges({
    required String email,
    required String password,
  }) async {
    _authSubscription?.cancel();
    _authSubscription =
        _emailSettingsRepository.userChanges().listen((user) async {
      if (user == null) {
        await _reauthenticateAndReload(email: email, password: password);
      } else {
        if (user.email == email && user.emailVerified) {
          _updateUser(email: user.email!);
        }
      }
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          user?.reload();
        },
      );
    });
  }

  Future<void> _reauthenticateAndReload({
    required String email,
    required String password,
  }) async {
    final result = await _emailSettingsRepository.reauthenticateWithCredential(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(EmailSettingsFailureState(message: failure.message)),
      (credential) async {
        await credential.user?.reload();
        if (isClosed) return;
        if (credential.user?.email == email) {
          _updateUser(email: email);
        } else {
          emit(EmailSettingsLogoutState());
        }
      },
    );
  }

  Future<void> _updateUser({required String email}) async {
    if (_authSubscription == null || isClosed) {
      return;
    }

    final updatedUser = _authCubit.currentUser!.copyWith(email: email);

    final updateUserResult =
        await _userRepository.updateUserToDatabase(updatedUser);
    if (isClosed) return;
    updateUserResult.fold(
      (failure) => emit(EmailSettingsFailureState(message: failure.message)),
      (_) {
        _authSubscription?.cancel();
        _authSubscription = null;
        if (state is! EmailSettingsSuccessState) {
          emit(EmailSettingsSuccessState(updatedUser: updatedUser));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
