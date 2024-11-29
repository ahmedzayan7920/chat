import 'package:flutter/foundation.dart';

import '../utils/app_strings.dart';

abstract class UserModelKeys {
  static const id = 'id';
  static const name = 'name';
  static const email = 'email';
  static const profilePictureUrl = 'profilePictureUrl';
  static const isOnline = 'isOnline';
  static const lastSeen = 'lastSeen';
  static const fcmTokens = 'fcmTokens';
  static const status = 'status';
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePictureUrl;
  final bool isOnline;
  final int lastSeen;
  final List<String> fcmTokens;
  final String status;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.isOnline,
    required this.lastSeen,
    required this.fcmTokens,
    required this.status,
  });

  factory UserModel.newUser({
    required String id,
    required String name,
    required String email,
    String? profilePictureUrl,
    String? status,
    List<String>? fcmTokens,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      profilePictureUrl: profilePictureUrl ?? AppStrings.emptyString,
      isOnline: true,
      lastSeen: DateTime.now().millisecondsSinceEpoch,
      fcmTokens: fcmTokens ?? [],
      status: status ?? AppStrings.defaultUserStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      UserModelKeys.id: id,
      UserModelKeys.name: name,
      UserModelKeys.email: email,
      UserModelKeys.profilePictureUrl: profilePictureUrl,
      UserModelKeys.isOnline: isOnline,
      UserModelKeys.lastSeen: lastSeen,
      UserModelKeys.fcmTokens: fcmTokens,
      UserModelKeys.status: status,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[UserModelKeys.id] ?? AppStrings.emptyString,
      name: json[UserModelKeys.name] ?? AppStrings.emptyString,
      email: json[UserModelKeys.email] ?? AppStrings.emptyString,
      profilePictureUrl:
          json[UserModelKeys.profilePictureUrl] ?? AppStrings.emptyString,
      isOnline: json[UserModelKeys.isOnline] ?? false,
      lastSeen: json[UserModelKeys.lastSeen] ?? 0,
      fcmTokens: List<String>.from(json[UserModelKeys.fcmTokens] ?? []),
      status: json[UserModelKeys.status] ?? AppStrings.emptyString,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
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
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      fcmTokens: fcmTokens ?? this.fcmTokens,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profilePictureUrl: $profilePictureUrl, isOnline: $isOnline, lastSeen: $lastSeen, fcmTokens: $fcmTokens, status: $status)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profilePictureUrl == profilePictureUrl &&
        other.isOnline == isOnline &&
        other.lastSeen == lastSeen &&
        listEquals(other.fcmTokens, fcmTokens) &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        profilePictureUrl.hashCode ^
        isOnline.hashCode ^
        lastSeen.hashCode ^
        fcmTokens.hashCode ^
        status.hashCode;
  }
}
