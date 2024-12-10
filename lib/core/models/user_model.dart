import 'package:flutter/foundation.dart';

import '../utils/app_strings.dart';

abstract class UserModelKeys {
  static const id = 'id';
  static const name = 'name';
  static const email = 'email';
  static const phoneNumber = 'phoneNumber';
  static const profilePictureUrl = 'profilePictureUrl';
  static const fcmTokens = 'fcmTokens';
  static const status = 'status';
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profilePictureUrl;
  final List<String> fcmTokens;
  final String status;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.fcmTokens,
    required this.status,
  });

  factory UserModel.newUser({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    String? profilePictureUrl,
    String? status,
    List<String>? fcmTokens,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profilePictureUrl: profilePictureUrl ?? AppStrings.emptyString,
      fcmTokens: fcmTokens ?? [],
      status: status ?? AppStrings.defaultUserStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      UserModelKeys.id: id,
      UserModelKeys.name: name,
      UserModelKeys.email: email,
      UserModelKeys.phoneNumber: phoneNumber,
      UserModelKeys.profilePictureUrl: profilePictureUrl,
      UserModelKeys.fcmTokens: fcmTokens,
      UserModelKeys.status: status,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[UserModelKeys.id] ?? AppStrings.emptyString,
      name: json[UserModelKeys.name] ?? AppStrings.emptyString,
      email: json[UserModelKeys.email] ?? AppStrings.emptyString,
      phoneNumber: json[UserModelKeys.phoneNumber] ?? AppStrings.emptyString,
      profilePictureUrl:
          json[UserModelKeys.profilePictureUrl] ?? AppStrings.emptyString,
      fcmTokens: List<String>.from(json[UserModelKeys.fcmTokens] ?? []),
      status: json[UserModelKeys.status] ?? AppStrings.emptyString,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
    bool? isOnline,
    int? lastSeen,
    List<String>? fcmTokens,
    String? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, profilePictureUrl: $profilePictureUrl, fcmTokens: $fcmTokens, status: $status)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profilePictureUrl == profilePictureUrl &&
        listEquals(other.fcmTokens, fcmTokens) &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePictureUrl.hashCode ^
        fcmTokens.hashCode ^
        status.hashCode;
  }
}
