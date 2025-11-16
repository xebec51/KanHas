import 'dart:io'; // Diperlukan untuk 'File'
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageHelper {

  // Fungsi ini akan kita panggil dari form kita
  // Dia mengembalikan 'String?' (path baru) atau 'null' (jika dibatalkan)
  static Future<String?> pickAndSaveImage() async {
    try {
      final picker = ImagePicker();

      // 1. Buka galeri dan biarkan pengguna memilih gambar
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      // Jika pengguna membatalkan, 'pickedFile' akan null
      if (pickedFile == null) return null;

      // 2. Dapatkan path ke folder dokumen internal aplikasi
      // Ini adalah tempat aman untuk menyimpan file
      final Directory appDir = await getApplicationDocumentsDirectory();

      // 3. Buat nama file yang unik (berdasarkan waktu)
      // Kita ambil ekstensi file aslinya (misal: .jpg, .png)
      final String fileExtension = pickedFile.path.split('.').last;
      final String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      // 4. Buat path baru yang permanen di dalam folder aplikasi
      final String permanentPath = '${appDir.path}/$fileName';

      // 5. Salin file dari 'cache' image_picker ke path permanen
      final File sourceFile = File(pickedFile.path);
      await sourceFile.copy(permanentPath);

      // 6. Kembalikan path permanen
      // Path ini yang akan kita simpan di CanteenModel
      return permanentPath;

    } catch (e) {
      // Jika terjadi error (misal: permission ditolak)
      debugPrint('Error picking and saving image: $e');
      return null;
    }
  }
}