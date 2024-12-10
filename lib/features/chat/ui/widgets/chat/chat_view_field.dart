import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/enums/message_type.dart';
import '../../../../../core/functions/build_field_border.dart';
import '../../../../../core/functions/show_snack_bar.dart';
import '../../../../../core/models/edit_media_arguments_model.dart';
import '../../../../../core/utils/app_media_picker.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../auth/logic/auth_cubit.dart';
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
  void dispose() {
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
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FieldIconButton(
                icon: Icons.video_collection_outlined,
                onPressed: () => _pickMedia(context, isVideo: true),
              ),
              _FieldIconButton(
                icon: Icons.image_outlined,
                onPressed: () => _pickMedia(context, isVideo: false),
              ),
              _FieldIconButton(
                icon: Icons.send_outlined,
                onPressed: _sendTextMessage,
              ),
            ],
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          border: buildFieldBorder(color: Colors.grey.shade400),
          enabledBorder:
              buildFieldBorder(color: Theme.of(context).colorScheme.tertiary),
          focusedBorder:
              buildFieldBorder(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  void _sendTextMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final currentUserId = context.read<AuthCubit>().currentUser!.id;
      final otherUserId = widget.chat.getOtherUserId(currentUserId);

      context.read<ChatCubit>().sendTextMessage(
            currentUserId: currentUserId,
            otherUserId: otherUserId,
            message: _messageController.text.trim(),
          );
      _messageController.clear();
    }
  }

  void _sendMediaMessage(String filePath, String caption, MessageType type) {
    final currentUserId = context.read<AuthCubit>().currentUser!.id;
    final otherUserId = widget.chat.getOtherUserId(currentUserId);

    context.read<ChatCubit>().sendMediaMessage(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
          message: caption,
          mediaPath: filePath,
          type: type,
        );
  }

  Future<void> _pickMedia(BuildContext context, {required bool isVideo}) async {
    try {
      final XFile? file = await AppMediaPicker.pickMedia(isVideo: isVideo);

      if (!context.mounted || file == null) return;

      await Navigator.of(context).pushNamed(
        AppRoutes.editMedia,
        arguments: EditMediaArgumentsModel(
          mediaPath: file.path,
          isVideo: isVideo,
          onSend: (String caption) {
            _sendMediaMessage(
              file.path,
              caption,
              isVideo ? MessageType.video : MessageType.image,
            );
          },
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      showSnackBar(context, '${AppStrings.failedToPickMedia} $e');
    }
  }
}

class _FieldIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _FieldIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: Theme.of(context).colorScheme.onSecondary,
    );
  }
}
