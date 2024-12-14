import 'package:flutter/foundation.dart';

import '../../../core/enums/message_type.dart';
import '../../../core/utils/app_strings.dart';

abstract class ChatModelKeys {
  static const id = 'id';
  static const members = 'members';
  static const lastMessageModel = 'lastMessageModel';
  static const lastMessage = 'lastMessage';
  static const lastMessageTime = 'lastMessageTime';
  static const type = 'type';
  static const isSeen = 'isSeen';
}

class ChatModel {
  final String id;
  final List<String> members;
  final String? userName;
  final String? userProfilePictureUrl;
  final LastMessageModel lastMessageModel;

  ChatModel({
    required this.id,
    required this.members,
    this.userName,
    this.userProfilePictureUrl,
    required this.lastMessageModel,
  });

  ChatModel copyWith({
    String? id,
    List<String>? members,
    String? userName,
    String? userProfilePictureUrl,
    LastMessageModel? lastMessageModel,
  }) {
    return ChatModel(
      id: id ?? this.id,
      members: members ?? this.members,
      userName: userName ?? this.userName,
      userProfilePictureUrl:
          userProfilePictureUrl ?? this.userProfilePictureUrl,
      lastMessageModel: lastMessageModel ?? this.lastMessageModel,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ChatModelKeys.id: id,
      ChatModelKeys.members: members,
      ChatModelKeys.lastMessageModel: lastMessageModel.toJson(),
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      id: map[ChatModelKeys.id] ?? AppStrings.emptyString,
      members: (map[ChatModelKeys.members] as List?)
              ?.map<String>((e) => e.toString())
              .toList() ??
          [],
      lastMessageModel:
          LastMessageModel.fromJson(map[ChatModelKeys.lastMessageModel]),
    );
  }
  @override
  String toString() {
    return 'ChatModel(id: $id, members: $members, userName: $userName, userProfilePictureUrl: $userProfilePictureUrl, lastMessageModel: $lastMessageModel)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.members, members) &&
        other.userName == userName &&
        other.userProfilePictureUrl == userProfilePictureUrl &&
        other.lastMessageModel == lastMessageModel;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        members.hashCode ^
        userName.hashCode ^
        userProfilePictureUrl.hashCode ^
        lastMessageModel.hashCode;
  }
}

class LastMessageModel {
  final String lastMessage;
  final int lastMessageTime;
  final MessageType type;
  final bool isSeen;

  LastMessageModel({
    required this.lastMessage,
    required this.lastMessageTime,
    required this.type,
    required this.isSeen,
  });

  LastMessageModel copyWith({
    String? lastMessage,
    int? lastMessageTime,
    MessageType? type,
    bool? isSeen,
  }) {
    return LastMessageModel(
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      type: type ?? this.type,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ChatModelKeys.lastMessage: lastMessage,
      ChatModelKeys.lastMessageTime: lastMessageTime,
      ChatModelKeys.type: type.name,
      ChatModelKeys.isSeen: isSeen,
    };
  }

  factory LastMessageModel.fromJson(Map<String, dynamic> map) {
    return LastMessageModel(
      lastMessage: map[ChatModelKeys.lastMessage] ?? AppStrings.emptyString,
      lastMessageTime: map[ChatModelKeys.lastMessageTime] ?? 0,
      type: MessageType.values.firstWhere(
        (e) => e.name == map[ChatModelKeys.type],
        orElse: () => MessageType.text,
      ),
      isSeen: map[ChatModelKeys.isSeen] ?? false,
    );
  }
  @override
  String toString() {
    return 'LastMessageModel(lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, type: $type, isSeen: $isSeen)';
  }

  @override
  bool operator ==(covariant LastMessageModel other) {
    if (identical(this, other)) return true;

    return other.lastMessage == lastMessage &&
        other.lastMessageTime == lastMessageTime &&
        other.type == type &&
        other.isSeen == isSeen;
  }

  @override
  int get hashCode {
    return lastMessage.hashCode ^
        lastMessageTime.hashCode ^
        type.hashCode ^
        isSeen.hashCode;
  }
}
