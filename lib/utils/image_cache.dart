import 'package:flutter/material.dart';

class ImageCacheHelper {
  static bool _isCached = false;

  static Future<void> precacheAllImages(BuildContext context) async {
    if (_isCached) return;
    _isCached = true;

    // Liste de toutes les images à précacher
    final imagePaths = [
      // Image principale
      'assets/images/Mont_St_Michel.jpg',

      // Images des méditations
      'assets/images/Baie1.jpeg',
      'assets/images/Baie2.jpeg',
      'assets/images/Baie3.jpg',
    ];

    // Précacher toutes les images
    for (final path in imagePaths) {
      try {
        await precacheImage(AssetImage(path), context);
      } catch (e) {
        // Ignore les erreurs de cache pour les images manquantes
        debugPrint('Failed to precache image: $path');
      }
    }
  }
}
