import '../../../models/chat_model.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/spaces.dart';
import 'chats_view_item.dart';

class ChatsViewSuccess extends StatelessWidget {
  const ChatsViewSuccess({super.key, required this.chats});
  final List<ChatModel> chats;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) => const VerticalSpace(height: 8),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatsViewItem(chat: chat);
      },
    );
  }
}
