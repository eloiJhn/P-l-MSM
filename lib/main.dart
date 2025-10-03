import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes.dart';
import 'theme.dart';
import 'providers.dart';
import 'data/assets_repository.dart';
import 'notifications/notification_service.dart';
import 'utils/image_cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('prefs');
  await Hive.openBox('favorites');

  // Notifications locales (programme)
  await LocalNotificationService.init();
  try {
    final days = await loadProgramme();
    await LocalNotificationService.scheduleProgrammeNotifications(days);
  } catch (_) {
    // Pas bloquant si l'init contenu échoue
  }
  runApp(const ProviderScope(child: PelerinageApp()));
}

class PelerinageApp extends ConsumerStatefulWidget {
  const PelerinageApp({super.key});

  @override
  ConsumerState<PelerinageApp> createState() => _PelerinageAppState();
}

class _PelerinageAppState extends ConsumerState<PelerinageApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Précache toutes les images au premier build
    ImageCacheHelper.precacheAllImages(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(isDark: false),
      darkTheme: buildAppTheme(isDark: true),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: goRouter,
    );
  }
}
