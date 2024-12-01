import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/chat/chat_cubit.dart';
import '../../../logic/chat/chat_state.dart';
import '../../../models/chat_model.dart';
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
              if (state is ChatLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ChatErrorState) {
                return Center(child: Text(state.message));
              } else if (state is ChatLoadedState) {
                return ChatViewSuccess(messages: state.messages);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
        ChatViewField(chat: chat),
      ],
    );
  }
}