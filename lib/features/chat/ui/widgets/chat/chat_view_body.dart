import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/chat/chat_cubit.dart';
import '../../../logic/chat/chat_state.dart';
import '../../../models/chat_model.dart';
import 'chat_view_error.dart';
import 'chat_view_field.dart';
import 'chat_view_success.dart';

class ChatViewBody extends StatelessWidget {
  const ChatViewBody({
    super.key,
    required this.chat,
  });

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return switch (state) {
                ChatErrorState() => ChatViewError(chat: chat, state: state),
                ChatLoadingState(isLoadingMore: false) =>
                  const Center(child: CircularProgressIndicator()),
                ChatLoadingState(isLoadingMore: true) => ChatViewSuccess(
                    messages: state.currentMessages,
                    chatId: chat.id,
                    hasMore: true,
                    isLoading: true,
                  ),
                ChatLoadedState() => ChatViewSuccess(
                    messages: state.messages,
                    chatId: chat.id,
                    hasMore: state.hasMore,
                    isLoading: false,
                  ),
                ChatInitialState() =>
                  const Center(child: CircularProgressIndicator()),
              };
            },
          ),
        ),
        ChatViewField(chat: chat),
      ],
    );
  }
}
