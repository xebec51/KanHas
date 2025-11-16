import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  static Future<String?> pickAndSaveImage() async {
    try {
      final picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return null;

      final Directory appDir = await getApplicationDocumentsDirectory();

      final String fileExtension = pickedFile.path.split('.').last;
      final String fileName =
          'img_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      final String permanentPath = '${appDir.path}/$fileName';

      final File sourceFile = File(pickedFile.path);
      await sourceFile.copy(permanentPath);

      return permanentPath;
    } catch (e) {
      debugPrint('Error picking and saving image: $e');
      return null;
    }
  }
}