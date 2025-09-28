import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pelerinage_msm/pages/meditations_page.dart';
import 'package:pelerinage_msm/data/models.dart';
import 'package:pelerinage_msm/providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('Prières utilisent les images dédiées (1/2/3)', (tester) async {
    final mockPrayers = [
      Prayer(
        id: 1,
        title: 'Prière à l’archange saint Michel',
        source: 'Pape Léon XIII',
        text: '...'
      ),
      Prayer(
        id: 2,
        title: 'Prière à Saint Michel Archange',
        source: 'Saint Louis de Gonzague',
        text: '...'
      ),
      Prayer(
        id: 3,
        title: 'Prière à Saint Michel Archange',
        source: 'Pape François',
        text: '...'
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prayersProvider.overrideWith((ref) async => mockPrayers),
          meditationsProvider.overrideWith((ref) async => <Meditation>[]),
        ],
        child: const MaterialApp(
          home: Scaffold(body: MeditationsPage()),
        ),
      ),
    );

    // Basculer sur l’onglet "Prières"
    await tester.tap(find.text('Prières'));
    await tester.pumpAndSettle();

    // Récupère les Image.asset des 3 cartes de prières
    final images = tester.widgetList<Image>(find.byType(Image)).toList();
    expect(images.length, 3);

    final assetNames = images.map((img) {
      final provider = img.image;
      if (provider is AssetImage) return provider.assetName;
      return '';
    }).toSet();

    expect(
      assetNames.contains('assets/images/Papa Léon XIII.jpeg'),
      isTrue,
      reason: 'Image du Pape Léon XIII manquante',
    );
    expect(
      assetNames.contains('assets/images/Saint Louis Gonzague.jpg'),
      isTrue,
      reason: 'Image de Saint Louis de Gonzague manquante',
    );
    expect(
      assetNames.contains('assets/images/Pape François.jpg'),
      isTrue,
      reason: 'Image du Pape François manquante',
    );
  });
}

