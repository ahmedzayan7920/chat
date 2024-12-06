import 'package:chat/core/utils/app_strings.dart';

abstract class MessageModelKeys {
  static const String id = 'id';
  static const String message = 'message';
  static const String senderId = 'senderId';
  static const String time = 'time';
  static const String type = 'type';
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
}

class MessageModel {
  final String id;
  final String message;
  final String senderId;
  final int time;
  final MessageType type;

  MessageModel({
    required this.id,
    required this.message,
    required this.senderId,
    required this.time,
    required this.type,
  });

  MessageModel copyWith({
    String? id,
    String? message,
    String? senderId,
    int? time,
    MessageType? type,
  }) {
    return MessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      time: time ?? this.time,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      MessageModelKeys.id: id,
      MessageModelKeys.message: message,
      MessageModelKeys.senderId: senderId,
      MessageModelKeys.time: time,
      MessageModelKeys.type: type.name,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> map) {
    return MessageModel(
      id: map[MessageModelKeys.id] ?? AppStrings.emptyString,
      message: map[MessageModelKeys.message] ?? AppStrings.emptyString,
      senderId: map[MessageModelKeys.senderId] ?? AppStrings.emptyString,
      time: map[MessageModelKeys.time] ?? 0,
      type: MessageType.values.firstWhere(
        (e) => e.name == map[MessageModelKeys.type],
        orElse: () => MessageType.text,
      ),
    );
  }
  @override
  String toString() {
    return 'MessageModel(id: $id, message: $message, senderId: $senderId, time: $time, type: $type)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        other.senderId == senderId &&
        other.time == time &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        senderId.hashCode ^
        time.hashCode ^
        type.hashCode;
  }
}
