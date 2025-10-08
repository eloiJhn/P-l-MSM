import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../theme.dart';

/// Écran d'onboarding qui met en avant les fonctionnalités iOS natives
/// pour satisfaire les critères d'Apple (Guideline 4.0)
class OnboardingPage extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingPage({super.key, required this.onComplete});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = [
    OnboardingSlide(
      icon: Icons.church,
      title: 'Bienvenue au pèlerinage',
      description:
          'Votre compagnon spirituel pour le pèlerinage du Mont Saint-Michel',
      color: kOutremer,
    ),
    OnboardingSlide(
      icon: Icons.music_note,
      title: 'Écoutez les chants',
      description:
          'Lecture audio avec accompagnement en arrière-plan\nFonctionnalité native iOS indisponible sur le web',
      color: kDore,
      badge: 'iOS natif',
    ),
    OnboardingSlide(
      icon: Icons.search,
      title: 'Recherche instantanée',
      description:
          'Recherchez parmi les 24 chants et prières\npar numéro ou titre en temps réel',
      color: kOutremer,
      badge: 'iOS natif',
    ),
    OnboardingSlide(
      icon: Icons.favorite,
      title: 'Sauvegardez vos favoris',
      description:
          'Marquez vos chants préférés avec stockage persistant\nlocal sur votre appareil iOS',
      color: kDore,
      badge: 'iOS natif',
    ),
    OnboardingSlide(
      icon: Icons.notifications_active,
      title: 'Rappels de prières',
      description:
          'Notifications locales pour les moments de prière\net événements du programme avec système de notifications iOS',
      color: kOutremer,
      badge: 'iOS natif',
    ),
    OnboardingSlide(
      icon: Icons.share,
      title: 'Partagez avec vos proches',
      description:
          'Partagez chants et prières via Messages, Mail, WhatsApp\navec le share sheet natif iOS',
      color: kOutremer,
      badge: 'iOS natif',
    ),
    OnboardingSlide(
      icon: Icons.offline_bolt,
      title: 'Disponible hors ligne',
      description:
          'Tout le contenu est accessible sans connexion internet\npendant votre pèlerinage',
      color: kDore,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final box = Hive.box('prefs');
    await box.put('hasSeenOnboarding', true);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlanc,
      body: SafeArea(
        child: Column(
          children: [
            // Bouton Skip
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Passer',
                    style: leagueSpartanStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kMarine,
                    ),
                  ),
                ),
              ),
            ),

            // PageView avec les slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildSlide(_slides[index]);
                },
              ),
            ),

            // Indicateurs de page
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? kOutremer
                          : kOutremer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Bouton Suivant/Commencer
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOutremer,
                    foregroundColor: kBlanc,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    style: leagueSpartanStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kBlanc,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône avec badge optionnel
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: slide.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  slide.icon,
                  size: 60,
                  color: slide.color,
                ),
              ),
              if (slide.badge != null)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kDore,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      slide.badge!,
                      style: leagueSpartanStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: kBlanc,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 40),

          // Titre
          Text(
            slide.title,
            style: leagueSpartanStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: kMarine,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            slide.description,
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: kNoir.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final String? badge;

  OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.badge,
  });
}
