import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
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
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: _messageController,
        decoration: InputDecoration(
          label: Text(
            AppStrings.sendMessageHint,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.perm_media_outlined),
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              IconButton(
                onPressed: _sendTextMessage,
                icon: Icon(Icons.send_outlined),
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ],
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          border: _buildBorder(color: Colors.grey.shade400),
          disabledBorder: _buildBorder(color: Colors.grey.shade300),
          enabledBorder:
              _buildBorder(color: Theme.of(context).colorScheme.tertiary),
          focusedBorder:
              _buildBorder(color: Theme.of(context).colorScheme.primary),
          errorBorder: _buildBorder(color: Colors.red),
          focusedErrorBorder: _buildBorder(color: Colors.red),
        ),
      ),
    );
  }

  _sendTextMessage() {
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
  }

  OutlineInputBorder _buildBorder({required Color color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color,
        width: 2,
        style: BorderStyle.solid,
      ),
    );
  }
}
