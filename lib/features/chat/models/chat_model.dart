import 'package:chat/features/chat/models/message_model.dart';
import 'package:flutter/foundation.dart';

import '../../../core/utils/app_strings.dart';

abstract class ChatModelKeys {
  static const id = 'id';
  static const members = 'members';
  static const lastMessage = 'lastMessage';
  static const lastMessageTime = 'lastMessageTime';
  static const type = 'type';
}

class ChatModel {
  final String id;
  final List<String> members;
  final String? userName;
  final String? userProfilePictureUrl;
  final String lastMessage;
  final int lastMessageTime;
  final MessageType type;

  ChatModel({
    required this.id,
    required this.members,
    this.userName,
    this.userProfilePictureUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.type,
  });

  ChatModel copyWith({
    String? id,
    List<String>? members,
    String? userName,
    String? userProfilePictureUrl,
    String? lastMessage,
    int? lastMessageTime,
    MessageType? type,
  }) {
    return ChatModel(
      id: id ?? this.id,
      members: members ?? this.members,
      userName: userName ?? this.userName,
      userProfilePictureUrl:
          userProfilePictureUrl ?? this.userProfilePictureUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ChatModelKeys.id: id,
      ChatModelKeys.members: members,
      ChatModelKeys.lastMessage: lastMessage,
      ChatModelKeys.lastMessageTime: lastMessageTime,
      ChatModelKeys.type: type.name,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      id: map[ChatModelKeys.id] ?? AppStrings.emptyString,
      members: (map[ChatModelKeys.members] as List?)
              ?.map<String>((e) => e.toString())
              .toList() ??
          [],
      lastMessage: map[ChatModelKeys.lastMessage] ?? AppStrings.emptyString,
      lastMessageTime: map[ChatModelKeys.lastMessageTime] ?? 0,
      type: MessageType.values.firstWhere(
        (e) => e.name == map[ChatModelKeys.type],
        orElse: () => MessageType.text,
      ),
    );
  }
  @override
  String toString() {
    return 'ChatModel(id: $id, members: $members, userName: $userName, userProfilePictureUrl: $userProfilePictureUrl, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, type: $type)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.members, members) &&
        other.userName == userName &&
        other.userProfilePictureUrl == userProfilePictureUrl &&
        other.lastMessage == lastMessage &&
        other.lastMessageTime == lastMessageTime&&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        members.hashCode ^
        userName.hashCode ^
        userProfilePictureUrl.hashCode ^
        lastMessage.hashCode ^
        lastMessageTime.hashCode^
        type.hashCode;
  }
}
