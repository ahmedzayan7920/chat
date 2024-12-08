import 'dart:io';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:chat/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoPath;
  final bool isLocal;

  const CustomVideoPlayer({
    super.key,
    required this.videoPath,
    this.isLocal = true,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late CachedVideoPlayerPlusController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.isLocal
        ? CachedVideoPlayerPlusController.file(File(widget.videoPath))
        : CachedVideoPlayerPlusController.networkUrl(
            Uri.parse(widget.videoPath),
          );
    _controller
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final videoAspectRatio = _controller.value.aspectRatio;
              double videoWidth = constraints.maxWidth;
              double videoHeight = videoWidth / videoAspectRatio;

              if (videoHeight > constraints.maxHeight) {
                videoHeight = constraints.maxHeight;
              }

              return Center(
                child: SizedBox(
                  width: videoWidth,
                  height: videoHeight,
                  child: CachedVideoPlayerPlus(_controller),
                ),
              );
            },
          ),
        ),
        _VideoPlayerControllers(controller: _controller),
      ],
    );
  }
}

class _VideoPlayerControllers extends StatelessWidget {
  const _VideoPlayerControllers({required this.controller});
  final CachedVideoPlayerPlusController controller;

  void _togglePlayback() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _replayVideo() {
    controller.seekTo(Duration.zero);
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: controller.value.isCompleted
                    ? _replayVideo
                    : _togglePlayback,
                icon: Icon(
                  controller.value.isPlaying
                      ? Icons.pause
                      : controller.value.isCompleted
                          ? Icons.replay_outlined
                          : Icons.play_arrow,
                ),
              ),
              Text(
                controller.value.position.formatDuration(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
                    thumbColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Slider(
                    value: controller.value.position.inMilliseconds.toDouble(),
                    min: 0.0,
                    max: controller.value.duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      controller.seekTo(
                        Duration(milliseconds: value.toInt()),
                      );
                    },
                  ),
                ),
              ),
              Text(
                controller.value.duration.formatDuration(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
