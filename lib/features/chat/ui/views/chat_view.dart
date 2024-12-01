import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../logic/chat/chat_cubit.dart';
import '../../models/chat_model.dart';
import '../widgets/chat/chat_app_bar_title.dart';
import '../widgets/chat/chat_view_body.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.chat});
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit(chatRepository: getIt())..fetchMessages(chatId: chat.id),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: ChatAppBarTitle(chat: chat),
        ),
        body: ChatViewBody(chat: chat),
      ),
    );
  }
}
