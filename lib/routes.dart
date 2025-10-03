import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/welcome_page.dart';
import 'pages/programme_page.dart';
import 'pages/chants_page.dart';
import 'pages/meditations_page.dart';
import 'theme.dart';

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
      builder: (context, state) => const RootScaffold(location: routeWelcome),
    ),
    GoRoute(
      path: routeProgramme,
      name: 'programme',
      builder: (context, state) => const RootScaffold(location: routeProgramme),
    ),
    GoRoute(
      path: routeChants,
      name: 'chants',
      builder: (context, state) => const RootScaffold(location: routeChants),
    ),
    GoRoute(
      path: routeMeditations,
      name: 'meditations',
      builder: (context, state) => const RootScaffold(location: routeMeditations),
    ),
  ],
);

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key, required this.location});

  final String location;

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  static const _tabs = <String>[
    routeWelcome,
    routeProgramme,
    routeChants,
    routeMeditations,
  ];

  // Pages créées une seule fois et gardées en mémoire
  static final List<Widget> _pages = const [
    WelcomePage(),
    ProgrammePage(),
    ChantsPage(),
    MeditationsPage(),
  ];

  int get _currentIndex {
    // Correspondance exacte pour éviter les conflits avec '/' qui match tout
    if (widget.location == routeWelcome) return 0;
    if (widget.location == routeProgramme) return 1;
    if (widget.location == routeChants) return 2;
    if (widget.location == routeMeditations) return 3;
    return 0; // par défaut sur Accueil
  }

  @override
  Widget build(BuildContext context) {
    // Espace dynamiquement la barre du bord bas: sur iPhone (home indicator),
    // on colle un peu plus (4px), sinon on laisse 8px.
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final double bottomGap = bottomInset > 0 ? 4.0 : 8.0;

    // Page d'accueil sans SafeArea en haut pour que l'image monte jusqu'à la status bar
    final isWelcomePage = widget.location == routeWelcome;
    final currentIndex = _currentIndex;

    return Scaffold(
      body: SafeArea(
        top: !isWelcomePage,
        child: IndexedStack(
          index: currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, bottomGap),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: kOutremer.withValues(alpha: 0.20),
                border: Border(
                  top: BorderSide(color: kMarine.withValues(alpha: 0.08), width: 1),
                ),
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  indicatorColor: kOutremer.withValues(alpha: 0.35),
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return leagueSpartanStyle(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      color: selected ? kMarine : kMarine.withValues(alpha: 0.75),
                    );
                  }),
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return IconThemeData(
                      color: selected ? kMarine : kMarine.withValues(alpha: 0.75),
                    );
                  }),
                ),
                child: NavigationBar(
                  height: 64,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (index) {
                    final target = _tabs[index];
                    if (target != widget.location) context.go(target);
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Placeholder classes removed; real pages imported above.
