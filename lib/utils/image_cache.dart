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

      // Images des chants (1-24)
      'assets/images/1.jpg',
      'assets/images/2.jpg',
      'assets/images/3.jpg',
      'assets/images/4.jpg',
      'assets/images/5.jpg',
      'assets/images/6.jpg',
      'assets/images/7.jpg',
      'assets/images/8jpg.jpg',
      'assets/images/9.jpg',
      'assets/images/10.jpg',
      'assets/images/11.jpeg',
      'assets/images/12.jpg',
      'assets/images/13.jpeg',
      'assets/images/14.jpg',
      'assets/images/15.jpg',
      'assets/images/16.jpg',
      'assets/images/17.jpg',
      'assets/images/18.jpg',
      'assets/images/19.jpg',
      'assets/images/20.jpg',
      'assets/images/21.jpg',
      'assets/images/22.jpg',
      'assets/images/23.jpg',
      'assets/images/24.jpg',

      // Images des méditations
      'assets/images/Baie1.jpeg',
      'assets/images/Baie2.jpeg',
      'assets/images/Baie3.jpg',

      // Images des prières
      'assets/images/Papa_Leon_XIII.jpeg',
      'assets/images/Saint_Louis_Gonzague.jpg',
      'assets/images/Pape_Francois.jpg',
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
