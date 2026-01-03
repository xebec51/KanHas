import 'dart:io';
import 'package:flutter/material.dart';

// Widget ini dapat menampilkan gambar dari path lokal atau URL jaringan
class LocalOrNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final IconData errorIcon;

  const LocalOrNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 120,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.errorIcon = Icons.broken_image,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = imageUrl.startsWith('http');

    Widget placeholder(IconData icon) {
      return Container(
        height: height,
        width: width,
        color: Colors.grey[300],
        child: Icon(icon, size: height / 2, color: Colors.grey),
      );
    }

    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            color: Colors.grey[300],
            child: const Center(
                child: CircularProgressIndicator(color: Colors.red)),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return placeholder(errorIcon);
        },
      );
    } else {
      return Image.file(
        File(imageUrl),
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return placeholder(errorIcon);
        },
      );
    }
  }
}
