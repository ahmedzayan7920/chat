import 'package:flutter/material.dart';

import '../../../../../core/enums/message_type.dart';
import '../../../../../core/widgets/spaces.dart';
import '../../../models/chat_model.dart';

class ChatsItemSubtitle extends StatelessWidget {
  const ChatsItemSubtitle({super.key, required this.chat});
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
    );

    if (chat.lastMessageModel.type == MessageType.text) {
      return Text(
        chat.lastMessageModel.lastMessage,
        style: subtitleTextStyle,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          _getIconForMessageType(chat.lastMessageModel.type),
          color: theme.colorScheme.primary,
        ),
        const HorizontalSpace(width: 4),
        Text(
          chat.lastMessageModel.lastMessage.isNotEmpty
              ? chat.lastMessageModel.lastMessage
              : chat.lastMessageModel.type.name.toUpperCase(),
          style: subtitleTextStyle,
        ),
      ],
    );
  }

  IconData _getIconForMessageType(MessageType type) {
    switch (type) {
      case MessageType.image:
        return Icons.image_outlined;
      case MessageType.video:
        return Icons.video_library_outlined;
      case MessageType.audio:
        return Icons.audio_file_outlined;
      case MessageType.file:
        return Icons.attach_file_outlined;
      case MessageType.text:
      default:
        return Icons.message_outlined;
    }
  }
}