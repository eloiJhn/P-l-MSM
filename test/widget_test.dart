// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pelerinage_msm/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('App builds and shows welcome content', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PelerinageApp()));
    await tester.pumpAndSettle();

    expect(find.text('Le Mont-Saint-Michel'), findsOneWidget);
    expect(find.text('ENTRER'), findsOneWidget);
  });

  testWidgets('Programme navigation does not expose Étapes tab',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PelerinageApp()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('ENTRER'));
    await tester.tap(find.text('ENTRER'));
    await tester.pumpAndSettle();

    expect(find.text('Programme'), findsWidgets);
    expect(find.text('Chants'), findsWidgets);
    expect(find.text('Méditations'), findsNothing);
    expect(find.text('Étapes'), findsNothing);
  });
}
