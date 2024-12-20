import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/spaces.dart';
import '../../../../auth/logic/auth_cubit.dart';
import '../../../models/message_model.dart';
import 'message_text_item.dart';

class MessageImageItem extends StatelessWidget {
  const MessageImageItem({
    super.key,
    required this.message,
    required this.size,
  });

  final MessageModel message;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bool isMyMessage =
        message.senderId == context.read<AuthCubit>().currentUser!.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.mediaUrl?.contains('http') ?? false)
          CachedNetworkImage(
            imageUrl: message.mediaUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                _ImageError(AppStrings.imageNotFound),
          )
        else
          Image.file(
            File(message.mediaUrl!),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _ImageError(AppStrings.failedToLoadImage),
          ),
        if (message.message.isNotEmpty) ...[
          const VerticalSpace(height: 4),
          MessageTextItem(
            message: message.message,
            isMyMessage: isMyMessage,
          ),
        ],
      ],
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError(this.errorMessage);
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onError,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
