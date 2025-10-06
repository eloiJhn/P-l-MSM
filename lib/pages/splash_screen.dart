import 'package:flutter/material.dart';
import 'dart:async';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Animation de fade in
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Animation de scale
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Animation de shimmer (effet brillant)
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );

    // Lancer les animations
    _fadeController.forward();
    _scaleController.forward();
    _shimmerController.repeat();

    // Transition vers la page d'accueil après 3 secondes
    Timer(const Duration(milliseconds: 3000), () {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF0A1628),
                    const Color(0xFF1A2F4A),
                    kMarine,
                  ]
                : [
                    kOutremer.withValues(alpha: 0.3),
                    kBlanc,
                    kOutremer.withValues(alpha: 0.2),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Effet de particules dorées flottantes
            ...List.generate(15, (index) {
              return Positioned(
                left: (index * 50) % MediaQuery.of(context).size.width,
                top: (index * 80) % MediaQuery.of(context).size.height,
                child: _GoldenParticle(delay: index * 200),
              );
            }),

            // Contenu principal centré
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image du Mont Saint-Michel avec effet d'ombre
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kDore.withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: kOutremer.withValues(alpha: 0.3),
                              blurRadius: 80,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/Mont_St_Michel.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Titre avec effet shimmer
                      AnimatedBuilder(
                        animation: _shimmerAnimation,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  isDarkMode ? kBlanc : kMarine,
                                  kDore,
                                  isDarkMode ? kBlanc : kMarine,
                                ],
                                stops: [
                                  0.0,
                                  _shimmerAnimation.value,
                                  1.0,
                                ],
                              ).createShader(bounds);
                            },
                            child: Text(
                              'Pèlerinage',
                              style: leagueSpartanStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 8),

                      // Sous-titre
                      Text(
                        'Mont Saint-Michel',
                        style: leagueSpartanStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? kOutremer.withValues(alpha: 0.9)
                              : kOutremer,
                          letterSpacing: 4,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 60),

                      // Indicateur de chargement personnalisé
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            kDore.withValues(alpha: 0.8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Message d'accueil
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Préparez votre cœur...',
                          style: leagueSpartanStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.7)
                                : kMarine.withValues(alpha: 0.7),
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Logo/Badge en bas
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Icon(
                      Icons.church,
                      size: 32,
                      color: isDarkMode
                          ? kDore.withValues(alpha: 0.5)
                          : kOutremer.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'MSM 2025',
                      style: leagueSpartanStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.5)
                            : kMarine.withValues(alpha: 0.5),
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget pour les particules dorées animées
class _GoldenParticle extends StatefulWidget {
  final int delay;

  const _GoldenParticle({required this.delay});

  @override
  State<_GoldenParticle> createState() => _GoldenParticleState();
}

class _GoldenParticleState extends State<_GoldenParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000 + (widget.delay % 1000)),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 4 + (widget.delay % 6),
        height: 4 + (widget.delay % 6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kDore.withValues(alpha: 0.6),
          boxShadow: [
            BoxShadow(
              color: kDore.withValues(alpha: 0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
