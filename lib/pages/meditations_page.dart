import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models.dart';
import '../providers.dart';
import '../theme.dart';

class MeditationsPage extends ConsumerWidget {
  const MeditationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMeditations = ref.watch(meditationsProvider);

    return asyncMeditations.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Erreur chargement méditations: $err'),
        ),
      ),
      data: (meditations) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Supprime l'espace inutile en haut
                  // const SizedBox(height: 1),
                  _PageHeader(),
                  // const SizedBox(height: 1),
                  // _ResultBadge(count: meditations.length),
                ],
              ),
            ),
            Expanded(
              child: Consumer(builder: (context, ref, _) {
                final prayersAsync = ref.watch(prayersProvider);
                final showPrayers = ref.watch(_showPrayersProvider);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    if (!showPrayers) ...[
                      _SectionTitle(
                        icon: Icons.auto_stories_outlined,
                        backgroundColor: _colorWithAlpha(kDore, 0.15),
                        iconColor: kDore,
                        title: 'Méditations',
                        subtitle: 'pour la traversée de la baie',
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(meditations.length, (index) {
                        final meditation = meditations[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _MeditationCard(
                            meditation: meditation,
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (_) => MeditationDetailPage(
                                    meditation: meditation,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ] else ...[
                      const _SectionTitle(
                        icon: Icons.volunteer_activism,
                        backgroundColor: Color(0x3381A3C1),
                        iconColor: kOutremer,
                        title: 'Prières',
                        subtitle: 'auprès de saint Michel',
                      ),
                      const SizedBox(height: 12),
                      prayersAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, s) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('Erreur chargement prières: $e'),
                        ),
                        data: (prayers) => Column(
                          children: [
                            for (final p in prayers)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _PrayerCard(
                                  prayer: p,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (_) => PrayerDetailPage(
                                          prayer: p,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

final _showPrayersProvider = StateProvider<bool>((ref) => false);

class _MedPraySwitch extends ConsumerWidget {
  const _MedPraySwitch({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPrayers = ref.watch(_showPrayersProvider);
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              selected: !showPrayers,
              icon: Icons.menu_book,
              label: 'Méditations',
              onTap: () =>
                  ref.read(_showPrayersProvider.notifier).state = false,
            ),
          ),
          Expanded(
            child: _SegmentButton(
              selected: showPrayers,
              icon: Icons.volunteer_activism,
              label: 'Prières',
              onTap: () => ref.read(_showPrayersProvider.notifier).state = true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.transparent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: selected ? kMarine : _colorWithAlpha(kMarine, 0.6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: leagueSpartanStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? kMarine : _colorWithAlpha(kMarine, 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MedPraySwitch(),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: kMarine,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _colorWithAlpha(kMarine, 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class _PrayersHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _colorWithAlpha(kOutremer, 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.volunteer_activism, color: kOutremer, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        )
      ],
    );
  }
}

class _PrayerCard extends StatelessWidget {
  const _PrayerCard({required this.prayer, required this.onTap});

  final Prayer prayer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 220,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: _colorWithAlpha(kOutremer, 0.12), width: 1),
            boxShadow: [
              BoxShadow(
                color: _colorWithAlpha(kMarine, 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _getPrayerImagePath(prayer.id),
                  fit: BoxFit.cover,
                  alignment: _getPrayerImageAlignment(prayer.id),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _colorWithAlpha(kNoir, 0.55),
                        _colorWithAlpha(kNoir, 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: kDore,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${prayer.id}',
                        style: leagueSpartanStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kBlanc,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prayer.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: kBlanc,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          if (prayer.source != null)
                            Text(
                              prayer.source!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _colorWithAlpha(kBlanc, 0.85),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- CLASSES ET FONCTIONS UTILITAIRES AU NIVEAU SUPERIEUR ---

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text('$count'), // À adapter selon le design souhaité
    );
  }
}

class _MeditationCard extends StatelessWidget {
  const _MeditationCard({
    required this.meditation,
    required this.onTap,
  });

  final Meditation meditation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 220,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _colorWithAlpha(kOutremer, 0.12),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _colorWithAlpha(kMarine, 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _getMeditationImagePath(meditation.id),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _colorWithAlpha(kNoir, 0.55),
                        _colorWithAlpha(kNoir, 0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: kDore,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${meditation.id}',
                            style: leagueSpartanStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kBlanc,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meditation.subtitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: kBlanc,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getMeditationImagePath(int meditationId) {
  switch (meditationId) {
    case 1:
      return 'assets/images/Baie1.jpeg';
    case 2:
      return 'assets/images/Baie2.jpeg';
    case 3:
      return 'assets/images/Baie3.jpg';
    default:
      return 'assets/images/Baie1.jpeg'; // fallback
  }
}

class MeditationDetailPage extends StatelessWidget {
  const MeditationDetailPage({super.key, required this.meditation});

  final Meditation meditation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe vers la droite pour retourner
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: kBlanc,
        appBar: AppBar(
          backgroundColor: kBlanc,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            // En-tête avec titre et sous-titre
            _buildHeader(theme),
            const SizedBox(height: 32),

            // Sections de la méditation
            ..._buildSections(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _colorWithAlpha(kDore, 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_stories, color: kDore, size: 20),
              const SizedBox(width: 8),
              Text(
                'Méditation ${meditation.id}',
                style: leagueSpartanStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kDore,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          meditation.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: kMarine,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          meditation.subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: _colorWithAlpha(kMarine, 0.7),
            fontStyle: FontStyle.italic,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildSections(ThemeData theme) {
    final widgets = <Widget>[];

    for (int i = 0; i < meditation.sections.length; i++) {
      final section = meditation.sections[i];

      widgets.add(_buildSection(section, theme));

      if (i < meditation.sections.length - 1) {
        widgets.add(const SizedBox(height: 24));
        widgets.add(_buildDivider());
        widgets.add(const SizedBox(height: 24));
      }
    }

    return widgets;
  }

  Widget _buildSection(MeditationSection section, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texte principal
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _colorWithAlpha(kOutremer, 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _colorWithAlpha(kOutremer, 0.1),
              width: 1,
            ),
          ),
          child: Text(
            section.text,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: _colorWithAlpha(kNoir, 0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // Points de réflexion
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...section.bullets.map((bullet) => _buildBulletPoint(bullet, theme)),
        ],

        // Prière
        if (section.prayer != null) ...[
          const SizedBox(height: 20),
          _buildPrayer(section.prayer!, theme),
        ],
      ],
    );
  }

  Widget _buildBulletPoint(String bullet, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _colorWithAlpha(kMarine, 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _colorWithAlpha(kMarine, 0.08),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: kDore,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                bullet,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: _colorWithAlpha(kNoir, 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayer(String prayer, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _colorWithAlpha(kDore, 0.1),
            _colorWithAlpha(kDore, 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _colorWithAlpha(kDore, 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: kDore,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Prière',
                style: leagueSpartanStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kDore,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            prayer,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: _colorWithAlpha(kNoir, 0.85),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
            child:
                Container(height: 1, color: _colorWithAlpha(kOutremer, 0.2))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: kDore,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
            child:
                Container(height: 1, color: _colorWithAlpha(kOutremer, 0.2))),
      ],
    );
  }
}

class PrayerDetailPage extends StatelessWidget {
  const PrayerDetailPage({super.key, required this.prayer});

  final Prayer prayer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: kBlanc,
        appBar: AppBar(
          backgroundColor: kBlanc,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            _buildHeader(theme),
            const SizedBox(height: 24),
            _buildPrayerBody(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _colorWithAlpha(kDore, 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.volunteer_activism, color: kDore, size: 20),
              const SizedBox(width: 8),
              Text(
                'Prière ${prayer.id}',
                style: leagueSpartanStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kDore,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          prayer.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: kMarine,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        if (prayer.source != null) ...[
          const SizedBox(height: 8),
          Text(
            prayer.source!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: _colorWithAlpha(kMarine, 0.7),
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildPrayerBody(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _colorWithAlpha(kOutremer, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _colorWithAlpha(kOutremer, 0.12), width: 1),
      ),
      child: Text(
        prayer.text,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.5,
          color: _colorWithAlpha(kNoir, 0.85),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

Color _colorWithAlpha(Color color, double opacity) {
  final clamped = opacity.clamp(0.0, 1.0);
  return color.withAlpha((clamped * 255).round());
}

String _getPrayerImagePath(int id) {
  // Mapping explicite demandé par l’équipe
  switch (id) {
    case 1:
      return 'assets/images/Papa_Leon_XIII.jpeg';
    case 2:
      return 'assets/images/Saint_Louis_Gonzague.jpg';
    case 3:
      return 'assets/images/Pape_Francois.jpg';
    default:
      // Fallback générique si de nouvelles prières arrivent sans image dédiée
      switch (id % 5) {
        case 1:
          return 'assets/images/1.jpg';
        case 2:
          return 'assets/images/2.jpg';
        case 3:
          return 'assets/images/3.jpg';
        case 4:
          return 'assets/images/4.jpg';
        default:
          return 'assets/images/5.jpg';
      }
  }
}

Alignment _getPrayerImageAlignment(int id) {
  // Ajuste le cadrage pour que le visage soit bien visible
  switch (id) {
    case 1: // Pape Léon XIII
      return const Alignment(0, -0.6); // remonter vers le haut
    case 2: // Saint Louis de Gonzague
      return const Alignment(0, -0.5); // remonter légèrement
    case 3: // Pape François
      return const Alignment(0, -0.1); // quasi centre
    default:
      return Alignment.center;
  }
}
