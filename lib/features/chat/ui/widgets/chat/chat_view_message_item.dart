import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/spaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/logic/auth_cubit.dart';
import '../../../models/message_model.dart';
import 'message_item_content.dart';

class ChatViewMessageItem extends StatelessWidget {
  const ChatViewMessageItem({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final isMyMessage =
        message.senderId == (context.read<AuthCubit>().currentUser!.id);
    final itemWidth = MediaQuery.of(context).size.width * .6;

    return Align(
      alignment: isMyMessage
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        padding: const EdgeInsets.all(8),
        constraints: BoxConstraints(maxWidth: itemWidth),
        decoration: BoxDecoration(
          color: isMyMessage
              ? Theme.of(context).colorScheme.inversePrimary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMyMessage ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMyMessage ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            MessageItemContent(
              message: message,
              isMyMessage: isMyMessage,
              size: itemWidth,
            ),
            VerticalSpace(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                message.time.formatIntTime(),
                style: TextStyle(
                  color: isMyMessage
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
