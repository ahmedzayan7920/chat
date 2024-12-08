class EditMediaArgumentsModel {
  final String mediaPath;
  final bool isVideo;
  final void Function(String caption) onSend;

  EditMediaArgumentsModel({
    required this.mediaPath,
    required this.isVideo,
    required this.onSend,
  });
}
