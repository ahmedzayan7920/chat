import 'dart:io';

import 'package:chat/core/extensions/extensions.dart';
import 'package:chat/features/chat/models/message_model.dart';
import 'package:chat/features/chat/ui/widgets/chat/message_text_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/widgets/spaces.dart';
import '../../../../auth/logic/auth_cubit.dart';

class MessageVideoItem extends StatelessWidget {
  const MessageVideoItem(
      {super.key, required this.message, required this.size});
  final MessageModel message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.videoPlayer,
          arguments: message.mediaUrl,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
            future: _getVideoThumbnail(message.mediaUrl!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.file(
                      File(snapshot.data as String),
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    ),
                    if (message.message.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          VerticalSpace(height: 4),
                          MessageTextItem(
                            message: message.message,
                            isMyMessage: message.senderId ==
                                context.read<AuthCubit>().currentUserId,
                          ),
                        ],
                      ),
                  ],
                );
              } else {
                return Container(
                  width: size,
                  height: size,
                  color: Colors.grey.shade300,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
          const Icon(
            Icons.play_circle_fill,
            size: 48,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future<String> _getVideoThumbnail(String videoUrl) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = '${tempDir.path}/thumbnail_${videoUrl.hashCode}.jpg';

    final file = File(thumbnailPath);
    if (await file.exists()) {
      return file.path;
    }

    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: thumbnailPath,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    );

    return thumbnail ?? '';
  }
}
