import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const SizedBox(height: 40),

              // Logo de l'app
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: kBlanc,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withValues(alpha: 0.3)
                          : kOutremer.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/Logo MSM Transparent.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Titre de l'app
              Text(
                'Pèlerinage MSM',
                style: leagueSpartanStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: isDarkMode ? kBlanc : kMarineFonce,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Version 1.0.0',
                style: leagueSpartanStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.6)
                      : kMarineFonce.withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: 48),

              // Message principal
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDarkMode
                        ? [kDore.withValues(alpha: 0.15), kOutremer.withValues(alpha: 0.15)]
                        : [kDore.withValues(alpha: 0.15), kOutremer.withValues(alpha: 0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDarkMode ? kDore.withValues(alpha: 0.3) : kDore.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 40,
                      color: isDarkMode ? kDore : kDore,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Amusez-vous bien pendant ce pèlerinage\net que Dieu vous protège !',
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.95)
                            : kMarineFonce,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Section développeur
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode ? kNoir.withValues(alpha: 0.3) : kBlanc,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withValues(alpha: 0.3)
                          : kMarineFonce.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Application développée par',
                      style: leagueSpartanStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.7)
                            : kMarineFonce.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Eloi Jahan',
                      style: leagueSpartanStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDarkMode ? kOutremer : kMarineFonce,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Bouton LinkedIn
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse('https://www.linkedin.com/in/eloi-jahan/');
                        try {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } catch (e) {
                          try {
                            await launchUrl(url);
                          } catch (e) {
                            debugPrint('Impossible d\'ouvrir LinkedIn: $e');
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDarkMode
                                ? [const Color(0xFF0077B5), const Color(0xFF005582)]
                                : [const Color(0xFF0077B5), const Color(0xFF0A66C2)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0077B5).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.business,
                              color: kBlanc,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Voir mon profil LinkedIn',
                              style: leagueSpartanStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: kBlanc,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Copyright
              Text(
                '© 2025 Pèlerinage MSM',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.5)
                      : kMarineFonce.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Fait avec ❤️ pour les pèlerins',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.5)
                      : kMarineFonce.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
