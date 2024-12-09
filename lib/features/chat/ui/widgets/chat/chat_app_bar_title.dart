import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/spaces.dart';
import '../../../models/chat_model.dart';

class ChatAppBarTitle extends StatelessWidget {
  const ChatAppBarTitle({
    super.key,
    required this.chat,
  });

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: chat.userProfilePictureUrl ?? AppStrings.emptyString,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                const Icon(Icons.person_outline),
          ),
        ),
        const HorizontalSpace(width: 10),
        Text(chat.userName ?? AppStrings.emptyString),
      ],
    );
  }
}
