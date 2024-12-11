import 'package:flutter/material.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileSuccessState extends ProfileState {}

final class ProfileFailureState extends ProfileState {
  final String message;

  ProfileFailureState({required this.message});
}
