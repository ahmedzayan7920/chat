import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../auth/logic/auth_cubit.dart';
import '../../../../auth/logic/auth_state.dart';
import '../../../logic/chat/chat_cubit.dart';
import '../../../models/chat_model.dart';

class ChatViewField extends StatefulWidget {
  const ChatViewField({
    super.key,
    required this.chat,
  });
  final ChatModel chat;

  @override
  State<ChatViewField> createState() => _ChatViewFieldState();
}

class _ChatViewFieldState extends State<ChatViewField> {
  final TextEditingController _messageController = TextEditingController();

  @override
  dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomTextFormField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        label: AppStrings.sendMessageHint,
        prefixIcon: Icons.message_outlined,
        controller: _messageController,
        suffixIcon: Icons.send_outlined,
        suffixOnPressed: () {
          if (_messageController.text.trim().isNotEmpty) {
            final currentUserId =
                (context.read<AuthCubit>().state as AuthenticatedState).user.id;
            final otherUserId = widget.chat.members.firstWhere(
              (element) => element != currentUserId,
              orElse: () {
                return currentUserId;
              },
            );
            context.read<ChatCubit>().sendTextMessage(
                  currentUserId: currentUserId,
                  otherUserId: otherUserId,
                  message: _messageController.text.trim(),
                );
            _messageController.clear();
          }
        },
      ),
    );
  }
}
