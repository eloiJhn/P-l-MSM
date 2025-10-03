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

// Historique de navigation global (partagé entre toutes les instances)
final _navigationHistory = <int>[0];

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
  void initState() {
    super.initState();
    // Ajouter la page actuelle à l'historique au démarrage
    final currentIndex = _currentIndex;
    if (_navigationHistory.isEmpty || _navigationHistory.last != currentIndex) {
      _navigationHistory.add(currentIndex);
    }
  }

  @override
  void didUpdateWidget(RootScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mettre à jour l'historique quand on change de page
    if (oldWidget.location != widget.location) {
      final newIndex = _currentIndex;
      if (_navigationHistory.isEmpty || _navigationHistory.last != newIndex) {
        _navigationHistory.add(newIndex);
      }
    }
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;

        // Naviguer vers la page précédente dans l'historique
        if (_navigationHistory.length > 1) {
          _navigationHistory.removeLast(); // Retire la page actuelle
          final previousIndex = _navigationHistory.last;
          final previousRoute = _tabs[previousIndex];
          context.go(previousRoute);
        } else if (currentIndex != 0) {
          // Fallback: retourner à l'accueil si pas d'historique
          context.go(routeWelcome);
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}

// Placeholder classes removed; real pages imported above.
