import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/widgets/custom_circle_network_image.dart';
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
      leading: CustomCircleNetworkImage(
        imageUrl: chat.userProfilePictureUrl,
        radius: 25,
      ),
      title: Text(
        chat.userName ?? AppStrings.emptyString,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: ChatsItemSubtitle(chat: chat),
      trailing: Text(
        chat.lastMessageModel.lastMessageTime.formatIntTime(),
      ),
    );
  }
}
