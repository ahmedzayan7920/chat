import 'dart:io';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/spaces.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_video_player.dart';

class EditMediaView extends StatefulWidget {
  final String mediaPath;
  final bool isVideo;
  final Function(String caption) onSend;

  const EditMediaView({
    super.key,
    required this.mediaPath,
    required this.isVideo,
    required this.onSend,
  });

  @override
  State<EditMediaView> createState() => _EditMediaViewState();
}

class _EditMediaViewState extends State<EditMediaView> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editMedia),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.isVideo
                ? CustomVideoPlayer(
                    videoPath: widget.mediaPath,
                    isLocal: true,
                  )
                : Image.file(
                    File(widget.mediaPath),
                    fit: BoxFit.contain,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _captionController,
                    label: AppStrings.addCaption,
                    prefixIcon: Icons.text_fields_outlined,
                  ),
                ),
                HorizontalSpace(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    widget.onSend(_captionController.text.trim());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
