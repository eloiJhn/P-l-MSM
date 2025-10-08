import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../providers.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return Container(
      color: isDarkMode ? const Color(0xFF121212) : Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.church,
                      size: 60,
                      color: kDore,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Guide MSM',
                      style: leagueSpartanStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: kOutremer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: leagueSpartanStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.6)
                            : kNoir.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Disclaimer principal
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.orange.withValues(alpha: 0.15)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Application non officielle',
                          style: leagueSpartanStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Cette application a été créée de manière indépendante par un passionné pour accompagner les pèlerins du Mont Saint-Michel.',
                      style: leagueSpartanStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.9)
                            : kNoir.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Elle n\'est pas affiliée au Mont Saint-Michel.',
                      style: leagueSpartanStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.9)
                            : kNoir.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description
              _buildSection(
                title: 'À propos',
                content:
                    'Guide MSM est une application destinée aux pèlerins souhaitant se préparer spirituellement pour leur parcours vers le Mont Saint-Michel. Elle fournit des ressources pratiques : programme, chants, méditations et prières.',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),

              // Fonctionnalités
              _buildSection(
                title: 'Fonctionnalités',
                isDarkMode: isDarkMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeature(
                        'Programme détaillé du pèlerinage', isDarkMode),
                    _buildFeature('Carnet de chants avec favoris', isDarkMode),
                    _buildFeature(
                        'Méditations pour la traversée de la baie', isDarkMode),
                    _buildFeature('Prières auprès de saint Michel', isDarkMode),
                    _buildFeature('Mode sombre / clair', isDarkMode),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Contact
              _buildSection(
                title: 'Contact',
                content:
                    'Cette application est un projet bénévole et indépendant. Pour toute question ou suggestion, n\'hésitez pas à me contacter.',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),

              // Cartes de contact
              Row(
                children: [
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.code,
                      label: 'GitHub',
                      url: 'https://github.com/eloiJhn',
                      color: isDarkMode
                          ? const Color(0xFF6e5494)
                          : const Color(0xFF6e5494),
                      isDarkMode: isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildContactCard(
                      icon: Icons.work,
                      label: 'LinkedIn',
                      url: 'https://www.linkedin.com/in/eloi-jahan/',
                      color: const Color(0xFF0077B5),
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Copyright
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '© 2025 Guide MSM\nProjet indépendant',
                    textAlign: TextAlign.center,
                    style: leagueSpartanStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.5)
                          : kNoir.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? content,
    Widget? child,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: leagueSpartanStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kOutremer,
          ),
        ),
        const SizedBox(height: 12),
        if (content != null)
          Text(
            content,
            style: leagueSpartanStyle(
              fontSize: 15,
              height: 1.6,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.85)
                  : kNoir.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        if (child != null) child,
      ],
    );
  }

  Widget _buildFeature(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: kDore,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: leagueSpartanStyle(
                fontSize: 15,
                height: 1.5,
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.85)
                    : kNoir.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String url,
    required Color color,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () async {
        try {
          final uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          // Ignorer l'erreur silencieusement
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: leagueSpartanStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
