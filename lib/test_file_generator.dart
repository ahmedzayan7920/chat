import 'dart:io';
import 'dart:typed_data';

class TestFileGenerator {
  /// Creates a temporary file in the system temp directory
  static Future<File> createTempFile({
    required String content,
    required String extension, // e.g., 'txt', 'png'
  }) async {
    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${tempDir.path}/test_$timestamp.$extension';
    
    final file = File(filePath);
    await file.writeAsString(content);
    return file;
  }

  /// Creates a temporary image file
  static Future<File> createTempImage({
    required String extension, // e.g., 'png', 'jpg'
  }) async {
    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${tempDir.path}/test_image_$timestamp.$extension';
    
    // Create a simple black square image (100x100 pixels)
    final pixels = List.generate(
      40000, // 100x100x4 (RGBA)
      (index) => index % 4 == 3 ? 255 : 0,
    );
    
    final file = File(filePath);
    await file.writeAsBytes(Uint8List.fromList(pixels));
    return file;
  }

  /// Cleans up temporary test files
  static Future<void> cleanup(List<File> files) async {
    for (final file in files) {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}