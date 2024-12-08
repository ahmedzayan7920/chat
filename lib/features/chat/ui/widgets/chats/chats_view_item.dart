import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../models/chat_model.dart';
import 'chats_item_subtitle.dart';

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
          errorWidget: (context, url, error) => const Icon(Icons.person_outline),
        ),
      ),
      title: Text(
        chat.userName ?? AppStrings.emptyString,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: ChatsItemSubtitle(chat: chat),
      trailing: Text(
        chat.lastMessageTime.formatIntTime(),
      ),
    );
  }
}

