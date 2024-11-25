import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/user_model.dart';
import '../repos/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitialState());

  UserModel? get currentUser {
    final currentState = state;
    if (currentState is AuthenticatedState) {
      return currentState.user;
    }
    return null;
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) {
        emit(const UnauthenticatedState());
      },
      (user) {
        if (user != null) {
          emit(AuthenticatedState(user: user));
        } else {
          emit(const UnauthenticatedState());
        }
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
      (failure) {
        emit(AuthErrorState(message: failure.message));
      },
      (user) {
        emit(AuthenticatedState(user: user));
      },
    );
  }

  Future<void> loginWithGoogle() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.loginWithGoogle();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }

  Future<void> loginWithFacebook() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.loginWithFacebook();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthenticatedState(user: user)),
    );
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthLoadingState());

    final result = await _authRepository.registerWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        emit(AuthErrorState(message: failure.message));
      },
      (user) {
        emit(AuthenticatedState(user: user));
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.logout();

    result.fold(
      (failure) {
        emit(AuthErrorState(message: failure.message));
      },
      (_) {
        emit(const UnauthenticatedState());
      },
    );
  }
}
