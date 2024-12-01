import 'package:flutter/material.dart';

import '../../../models/message_model.dart';
import 'chat_view_message_item.dart';

class ChatViewSuccess extends StatelessWidget {
  const ChatViewSuccess({
    super.key,
    required this.messages,
  });
  final List<MessageModel> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatViewMessageItem(message: message);
      },
    );
  }
}