import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:hive/hive.dart';

import 'package:pelerinage_msm/pages/programme_page.dart';
import 'package:pelerinage_msm/pages/chants_page.dart';
import 'package:pelerinage_msm/data/models.dart';
import 'package:pelerinage_msm/providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('ProgrammePage', () {
    testWidgets('switches agenda content when selecting a day', (tester) async {
      final mockDays = [
        ProgrammeDay(
          date: '2025-10-11',
          label: 'Samedi',
          entries: [
            ProgrammeEntry(time: '08:00', title: 'Accueil', place: 'Parvis'),
            ProgrammeEntry(time: '09:00', title: 'Départ', place: 'Parvis'),
          ],
        ),
        ProgrammeDay(
          date: '2025-10-12',
          label: 'Dimanche',
          entries: [
            ProgrammeEntry(time: '08:00', title: 'Laudes'),
          ],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [programmeProvider.overrideWith((ref) async => mockDays)],
          child: const MaterialApp(home: ProgrammePage()),
        ),
      );

      // Let FutureProvider resolve
      await tester.pumpAndSettle();

      // Default agenda shows the first day only
      expect(find.text('Samedi'), findsWidgets);
      expect(find.text('2025-10-11'), findsWidgets);
      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Laudes'), findsNothing);

      // Switch to the second day
      await tester.tap(find.text('Dimanche').first);
      await tester.pumpAndSettle();

      expect(find.text('Dimanche'), findsWidgets);
      expect(find.text('2025-10-12'), findsWidgets);
      expect(find.text('Laudes'), findsOneWidget);
      expect(find.text('Accueil'), findsNothing);
    });
  });

  group('ChantsPage', () {
    late Directory tmpDir;
    setUpAll(() async {
      tmpDir = await Directory.systemTemp.createTemp('hive_test_');
      Hive.init(tmpDir.path);
      await Hive.openBox('favorites');
    });

    tearDown(() async {
      await Hive.box('favorites').clear();
    });

    tearDownAll(() async {
      await Hive.close();
      try {
        await tmpDir.delete(recursive: true);
      } catch (_) {}
    });

    testWidgets('filters by title and toggles favorites', (tester) async {
      final mockChants = [
        Chant(
            id: 1,
            title: 'Chant Alpha',
            refrain: ['Ref A'],
            verses: ['V1', 'V2']),
        Chant(id: 2, title: 'Beta Chant', refrain: ['Ref B'], verses: ['V1']),
        Chant(id: 3, title: 'Gamma', refrain: ['Ref C'], verses: ['V1']),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [chantsProvider.overrideWith((ref) async => mockChants)],
          child: const MaterialApp(home: Scaffold(body: ChantsPage())),
        ),
      );

      // Wait for initial load (avoid pumpAndSettle with stream-based widgets)
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Info badge shows 3 résultats initially
      expect(find.textContaining('3 résultat'), findsOneWidget);

      // Type a query that matches one item by title
      await tester.enterText(find.byType(TextField), 'beta');
      await tester.pumpAndSettle();

      expect(find.textContaining('1 résultat'), findsOneWidget);
      expect(find.text('Beta Chant'), findsOneWidget);
      expect(find.text('Chant Alpha'), findsNothing);

      // Search by number should also work
      await tester.enterText(find.byType(TextField), '1');
      await tester.pumpAndSettle();

      expect(find.textContaining('1 résultat'), findsOneWidget);
      expect(find.text('Chant Alpha'), findsOneWidget);
      expect(find.text('Beta Chant'), findsNothing);

      // Toggle favorite on the visible item (id 1)
      final favButton =
          find.widgetWithIcon(IconButton, Icons.favorite_border).first;
      await tester.tap(favButton);
      await tester.pump(const Duration(milliseconds: 50));

      // Check Hive updated (clé string, comme dans l’app)
      final box = Hive.box('favorites');
      expect(box.get('1', defaultValue: false), isTrue);
    });
  });
}
