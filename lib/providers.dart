import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'data/assets_repository.dart';
import 'data/models.dart';
import 'services/audio_service.dart';

// Thème sombre/clair
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final box = Hive.box('prefs');
    state = box.get('isDarkMode', defaultValue: false) as bool;
  }

  Future<void> toggleTheme() async {
    state = !state;
    final box = Hive.box('prefs');
    await box.put('isDarkMode', state);
  }
}

// Lecture des contenus (assets)
final programmeProvider = FutureProvider<List<ProgrammeDay>>((ref) => loadProgramme());

final programmeSelectedDayIndexProvider = StateProvider<int>((ref) => 0);

final chantsProvider = FutureProvider<List<Chant>>((ref) => loadChants());

final meditationsProvider = FutureProvider<List<Meditation>>((ref) => loadMeditations());

final prayersProvider = FutureProvider<List<Prayer>>((ref) => loadPrayers());

// État de recherche pour la liste des chants
final chantsQueryProvider = StateProvider<String>((ref) => '');

// Filtre pour afficher seulement les favoris
final showOnlyFavoritesProvider = StateProvider<bool>((ref) => false);

// Favoris (Hive)
final favoritesBoxProvider = Provider<Box<dynamic>>((ref) => Hive.box('favorites'));

// État favori réactif pour un chant donné (mise à jour via box.watch)
final isFavoriteProvider = StreamProvider.family<bool, int>((ref, chantId) async* {
  final box = ref.watch(favoritesBoxProvider);
  final key = chantId.toString();
  // valeur initiale
  yield (box.get(key, defaultValue: false) as bool) == true;
  // mises à jour
  await for (final event in box.watch(key: key)) {
    yield (event.value as bool?) == true;
  }
});

// Action: toggle favori pour un chant (écrit dans Hive)
Future<void> toggleFavorite(int chantId) async {
  final box = Hive.box('favorites');
  final key = chantId.toString();
  final current = (box.get(key, defaultValue: false) as bool) == true;
  if (current) {
    await box.delete(key);
  } else {
    await box.put(key, true);
  }
}

// Obtenir la liste des IDs de chants favoris
List<int> getFavoriteChantIds() {
  final box = Hive.box('favorites');
  return box.keys
      .where((key) => (box.get(key, defaultValue: false) as bool) == true)
      .map((key) => int.tryParse(key.toString()) ?? 0)
      .where((id) => id > 0)
      .toList();
}

// Service audio pour les chants
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  service.init();
  return service;
});
