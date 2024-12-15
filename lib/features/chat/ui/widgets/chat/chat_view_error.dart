import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/chat/chat_cubit.dart';
import '../../../logic/chat/chat_state.dart';
import '../../../models/chat_model.dart';
import 'chat_view_success.dart';

class ChatViewError extends StatelessWidget {
  const ChatViewError({
    super.key,
    required this.chat, required this.state,
  });

  final ChatModel chat;
  final ChatErrorState state ;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: Text(state.message)),
                IconButton(
                  onPressed: () {
                    context
                        .read<ChatCubit>()
                        .loadMoreMessages(chatId: chat.id);
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            if (state.currentMessages.isNotEmpty)
              Expanded(
                child: ChatViewSuccess(
                  messages: state.currentMessages,
                  chatId: chat.id,
                  hasMore: false,
                  isLoading: false,
                ),
              ),
          ],
        ),
      );
  }
}