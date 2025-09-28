import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/welcome_page.dart';
import 'pages/programme_page.dart';
import 'pages/chants_page.dart';
import 'pages/meditations_page.dart';

// Paths
const String routeWelcome = '/';
const String routeProgramme = '/programme';
const String routeChants = '/chants';
const String routeMeditations = '/meditations';

final GoRouter goRouter = GoRouter(
  initialLocation: routeWelcome,
  routes: [
    GoRoute(
      path: routeWelcome,
      name: 'welcome',
      builder: (context, state) => const RootScaffold(
        location: routeWelcome,
        child: WelcomePage(),
      ),
    ),
    GoRoute(
      path: routeProgramme,
      name: 'programme',
      builder: (context, state) => const RootScaffold(
        location: routeProgramme,
        child: ProgrammePage(),
      ),
    ),
    GoRoute(
      path: routeChants,
      name: 'chants',
      builder: (context, state) => const RootScaffold(
        location: routeChants,
        child: ChantsPage(),
      ),
    ),
    GoRoute(
      path: routeMeditations,
      name: 'meditations',
      builder: (context, state) => const RootScaffold(
        location: routeMeditations,
        child: MeditationsPage(),
      ),
    ),
  ],
);

class RootScaffold extends StatelessWidget {
  const RootScaffold({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  static const _tabs = <String>[
    routeWelcome,
    routeProgramme,
    routeChants,
    routeMeditations,
  ];

  int get _currentIndex {
    // Correspondance exacte pour éviter les conflits avec '/' qui match tout
    if (location == routeWelcome) return 0;
    if (location == routeProgramme) return 1;
    if (location == routeChants) return 2;
    if (location == routeMeditations) return 3;
    return 0; // par défaut sur Accueil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(location),
            child: child,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          final target = _tabs[index];
          if (target != location) context.go(target);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: 'Programme',
          ),
          NavigationDestination(icon: Icon(Icons.music_note), label: 'Chants'),
          NavigationDestination(
            icon: Icon(Icons.auto_stories),
            label: 'Méditations',
          ),
        ],
      ),
    );
  }
}

// Placeholder classes removed; real pages imported above.
