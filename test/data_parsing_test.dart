import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pelerinage_msm/data/assets_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  test('loadProgramme returns non-empty days and entries', () async {
    // Ensure rootBundle is available
    expect(rootBundle, isNotNull);

    final days = await loadProgramme();
    expect(days, isNotEmpty);
    expect(days.first.entries, isNotEmpty);
    // Basic shape checks
    expect(days.first.date, isNotEmpty);
    expect(days.first.label, isNotEmpty);
    expect(days.first.entries.first.time, isNotEmpty);
    expect(days.first.entries.first.title, isNotEmpty);
  });

  test('loadChants returns non-empty list with integer ids', () async {
    final chants = await loadChants();
    expect(chants, isNotEmpty);
    expect(chants.first.id, isA<int>());
    expect(chants.first.title, isNotEmpty);
    expect(chants.first.refrain, isNotEmpty);
  });
}
