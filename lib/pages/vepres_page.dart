import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models.dart';
import '../providers.dart';
import '../theme.dart';

// Provider pour l'index de section sélectionnée
final vepresSelectedSectionProvider = StateProvider<int>((ref) => 0);

class VepresPage extends ConsumerWidget {
  const VepresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vepresAsync = ref.watch(vepresProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return vepresAsync.when(
      data: (vepresDay) =>
          _buildVepresContent(context, ref, vepresDay, isDarkMode),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Erreur de chargement: $error'),
        ),
      ),
    );
  }

  Widget _buildVepresContent(BuildContext context, WidgetRef ref,
      VepresDay vepresDay, bool isDarkMode) {
    final selectedIndex = ref.watch(vepresSelectedSectionProvider);

    return Scaffold(
      body: Column(
        children: [
          // Menu horizontal défilant des sections (avec SafeArea pour le haut uniquement)
          SafeArea(
            bottom: false,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: isDarkMode ? kNoir.withValues(alpha: 0.2) : kBlanc,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode
                        ? Colors.white.withValues(alpha: 0.1)
                        : kMarineFonce.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: vepresDay.sections.length,
                itemBuilder: (context, index) {
                  final section = vepresDay.sections[index];
                  final isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      ref.read(vepresSelectedSectionProvider.notifier).state =
                          index;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDarkMode
                                ? kOutremer.withValues(alpha: 0.25)
                                : kOutremer.withValues(alpha: 0.2))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(
                                color: isDarkMode ? kOutremer : kOutremer,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _getSectionLabel(section.type),
                          style: leagueSpartanStyle(
                            fontSize: 15,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected
                                ? (isDarkMode ? kBlanc : kMarineFonce)
                                : (isDarkMode
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : kMarineFonce.withValues(alpha: 0.5)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Contenu de la section sélectionnée
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildSectionContent(
                  vepresDay.sections[selectedIndex], isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(VepresSection section, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Afficher l'occasion pour l'introduction
        if (section.type == 'introduction') ...[
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [kOutremer.withValues(alpha: 0.3), kMarine.withValues(alpha: 0.3)]
                      : [kOutremer.withValues(alpha: 0.15), kMarine.withValues(alpha: 0.15)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? kOutremer.withValues(alpha: 0.4) : kOutremer.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Text(
                '27ᵉ Semaine du Temps Ordinaire',
                style: leagueSpartanStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? kOutremer : kMarineFonce,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],

        // Titre de la section
        if (section.title != null) ...[
          Text(
            section.title!.toUpperCase(),
            style: leagueSpartanStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isDarkMode ? kDore : kMarineFonce,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Sous-titre
        if (section.subtitle != null) ...[
          Text(
            section.subtitle!,
            style: leagueSpartanStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.75)
                  : kMarineFonce.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Antienne
        if (section.antienne != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? kDore.withValues(alpha: 0.12)
                  : kDore.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? kDore.withValues(alpha: 0.35)
                    : kDore.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Text(
              section.antienne!,
              style: TextStyle(
                fontSize: 15.5,
                height: 1.7,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? kDore : kMarineFonce,
              ),
            ),
          ),
        ],

        // Contenu avec refrain inséré entre les couplets
        ...(() {
          final List<Widget> widgets = [];
          final List<String> refrainLines = [];

          // Extraire le refrain (lignes qui commencent par R/)
          for (var line in section.content) {
            if (line.trim().startsWith('R/')) {
              refrainLines.add(line);
            }
          }

          bool lastWasVerse = false;

          for (int i = 0; i < section.content.length; i++) {
            final line = section.content[i];

            if (line.trim().isEmpty) {
              // Si la ligne vide suit un couplet et qu'on a un refrain, insérer le refrain
              if (lastWasVerse &&
                  refrainLines.isNotEmpty &&
                  i + 1 < section.content.length) {
                final nextLine = section.content[i + 1];
                final nextIsVerse =
                    RegExp(r'^\d+\s*-').hasMatch(nextLine.trim());

                if (nextIsVerse) {
                  // Ajouter le titre "Refrain" en jaune
                  widgets.add(const SizedBox(height: 20));
                  widgets.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Refrain',
                        style: leagueSpartanStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kDore,
                        ),
                      ),
                    ),
                  );

                  // Ajouter toutes les lignes du refrain en gras (y compris la 2ème ligne)
                  for (int j = 0; j < refrainLines.length; j++) {
                    widgets.add(
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          refrainLines[j],
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode
                                ? Colors.white.withValues(alpha: 0.95)
                                : kNoir.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    );
                  }

                  // La 2ème ligne est déjà dans refrainLines (vient du JSON)

                  widgets.add(const SizedBox(height: 16));
                  lastWasVerse = false;
                  continue;
                }
              }

              widgets.add(const SizedBox(height: 16));
              lastWasVerse = false;
              continue;
            }

            // Détection du refrain (commence par R/)
            final isRefrain = line.trim().startsWith('R/');

            // Détection des numéros de couplets (1 -, 2 -, etc.)
            final verseMatch =
                RegExp(r'^(\d+)\s*-\s*(.*)$').firstMatch(line.trim());
            final isVerse = verseMatch != null;

            if (isVerse) {
              lastWasVerse = true;
              // Titre du couplet en bleu
              widgets.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 16),
                  child: Text(
                    '${verseMatch.group(1)}.',
                    style: leagueSpartanStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? kOutremer : kMarine,
                    ),
                  ),
                ),
              );

              // Texte du couplet
              widgets.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    verseMatch.group(2)!,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.95)
                          : kNoir.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
              continue;
            }

            // Si c'est le refrain initial au début
            if (isRefrain && i < 10) {
              if (i == 0 ||
                  (i > 0 && !section.content[i - 1].trim().startsWith('R/'))) {
                // Titre "Refrain" en jaune
                widgets.add(
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, top: i == 0 ? 0 : 16),
                    child: Text(
                      'Refrain',
                      style: leagueSpartanStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kDore,
                      ),
                    ),
                  ),
                );
              }

              // Ligne du refrain en gras
              widgets.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    line,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.95)
                          : kNoir.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              );

              // La 2ème ligne est déjà dans le JSON, pas besoin de l'ajouter

              continue;
            }

            // Lignes normales
            if (!isRefrain) {
              widgets.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    line,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.95)
                          : kNoir.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            }
          }

          return widgets;
        })(),

        const SizedBox(height: 24),
      ],
    );
  }

  String _getSectionLabel(String type) {
    switch (type) {
      case 'introduction':
        return 'Introduction';
      case 'hymne':
        return 'Hymne';
      case 'psaume':
        return 'Psaume';
      case 'cantique':
        return 'Cantique';
      case 'parole':
        return 'Parole de Dieu';
      case 'repons':
        return 'Répons';
      case 'intercession':
        return 'Intercession';
      case 'notre_pere':
        return 'Notre Père';
      case 'oraison':
        return 'Oraison';
      default:
        return type;
    }
  }
}
