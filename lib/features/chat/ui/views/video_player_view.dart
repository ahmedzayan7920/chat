import '../../../../core/utils/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_video_player.dart';

class VideoPlayerView extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerView({
    super.key,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.video),
      ),
      body: Center(
        child: CustomVideoPlayer(videoPath: videoUrl, isLocal: false),
      ),
    );
  }
}
