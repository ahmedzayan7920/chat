import 'package:chat/core/widgets/custom_circle_network_image.dart';
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
        CustomCircleNetworkImage(
          imageUrl: chat.userProfilePictureUrl,
          radius: 20,
        ),
        const HorizontalSpace(width: 10),
        Text(chat.userName ?? AppStrings.emptyString),
      ],
    );
  }
}
