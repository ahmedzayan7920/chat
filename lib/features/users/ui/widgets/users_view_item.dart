import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/message_type.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../auth/logic/auth_cubit.dart';
import '../../../chat/models/chat_model.dart';

class UsersViewItem extends StatelessWidget {
  const UsersViewItem({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final List<String> members = [
          (context.read<AuthCubit>().currentUser!.id),
          user.id,
        ];
        ChatModel chat = ChatModel(
          id: members.generateChatId(),
          members: members,
          userName: user.name,
          userProfilePictureUrl: user.profilePictureUrl,
          lastMessageModel: LastMessageModel(
            lastMessage: '',
            lastMessageTime: 0,
            type: MessageType.text,
            isSeen: false,
          ),
        );
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.chat,
          arguments: chat,
        );
      },
      minLeadingWidth: 50,
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: user.profilePictureUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) =>
              const Icon(Icons.person_outline),
        ),
      ),
      title: Text(user.name),
      subtitle: Text(user.email.isEmpty ? user.phoneNumber : user.email),
    );
  }
}
