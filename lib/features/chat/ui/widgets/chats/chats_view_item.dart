import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../models/chat_model.dart';

class ChatsViewItem extends StatelessWidget {
  const ChatsViewItem({
    super.key,
    required this.chat,
  });

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.chat,
          arguments: chat,
        );
      },
      minLeadingWidth: 50,
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: chat.userProfilePictureUrl ?? AppStrings.emptyString,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        chat.userName ?? AppStrings.emptyString,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        chat.lastMessage,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
      trailing: Text(
        chat.lastMessageTime.formatTime(),
      ),
    );
  }
}
