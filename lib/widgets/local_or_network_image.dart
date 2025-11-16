import 'dart:io';
import 'package:flutter/material.dart';

// Ini adalah widget 'pintar' kita
class LocalOrNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final IconData errorIcon; // Ikon jika error

  const LocalOrNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 120, // Beri nilai default
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.errorIcon = Icons.broken_image, // 1. TAMBAHKAN INI
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah ini path lokal atau URL web
    final bool isNetworkImage = imageUrl.startsWith('http');

    // Widget placeholder untuk 'error'
    Widget placeholder(IconData icon) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey[300],
        child: Icon(icon, size: height / 2, color: Colors.grey),
      );
    }

    if (isNetworkImage) {
      // JIKA INI URL WEB:
      return Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child; // Gambar selesai
          return Container( // Tampilkan placeholder
            height: height,
            width: width,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator(color: Colors.red)),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return placeholder(errorIcon); // 2. Gunakan 'errorIcon' dari parameter
        },
      );
    } else {
      // JIKA INI FILE LOKAL:
      return Image.file(
        File(imageUrl), // Gunakan Image.file
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return placeholder(errorIcon); // 3. Gunakan 'errorIcon' dari parameter
        },
      );
    }
  }
}