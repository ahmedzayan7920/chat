import 'package:image_picker/image_picker.dart';

abstract class AppMediaPicker {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickMedia({required bool isVideo}) async {
    try {
      return isVideo
          ? await _picker.pickVideo(source: ImageSource.gallery)
          : await _picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      rethrow;
    }
  }
}
