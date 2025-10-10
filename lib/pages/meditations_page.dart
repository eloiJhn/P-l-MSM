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
    final isDarkMode = ref.watch(themeProvider);

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
                  _PageHeader(isDarkMode: isDarkMode),
                  // const SizedBox(height: 1),
                  // _ResultBadge(count: meditations.length),
                ],
              ),
            ),
            Expanded(
              child: Consumer(builder: (context, ref, _) {
                final prayersAsync = ref.watch(prayersProvider);
                final fratsAsync = ref.watch(fratsProvider);
                final view = ref.watch(_medPrayFratProvider);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  children: [
                    if (view == _MedPrayFrat.meditations) ...[
                      _SectionTitle(
                        icon: Icons.auto_stories_outlined,
                        backgroundColor: _colorWithAlpha(kDore, 0.15),
                        iconColor: kDore,
                        title: 'Méditations',
                        subtitle: 'pour la traversée de la baie',
                        isDarkMode: isDarkMode,
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
                    ] else if (view == _MedPrayFrat.prieres) ...[
                      _SectionTitle(
                        icon: Icons.volunteer_activism,
                        backgroundColor: _colorWithAlpha(kDore, 0.15),
                        iconColor: kDore,
                        title: 'Prières',
                        subtitle: 'auprès de saint Michel',
                        isDarkMode: isDarkMode,
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
                                child: _PrayerListCard(
                                  prayer: p,
                                  isDarkMode: isDarkMode,
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
                    ] else ...[
                      _SectionTitle(
                        icon: Icons.group,
                        backgroundColor: _colorWithAlpha(kDore, 0.15),
                        iconColor: kDore,
                        title: 'Temps de frat',
                        subtitle: 'questions pour partager',
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(height: 12),
                      fratsAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, s) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text('Erreur chargement frat: $e'),
                        ),
                        data: (topics) => Column(
                          children: [
                            for (final t in topics)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child:
                                    _FratCard(topic: t, isDarkMode: isDarkMode),
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

enum _MedPrayFrat { meditations, prieres, frats }

final _medPrayFratProvider =
    StateProvider<_MedPrayFrat>((ref) => _MedPrayFrat.meditations);

class _MedPraySwitch extends ConsumerWidget {
  const _MedPraySwitch({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(_medPrayFratProvider);
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
              selected: current == _MedPrayFrat.meditations,
              icon: Icons.menu_book,
              label: 'Méditations',
              onTap: () => ref.read(_medPrayFratProvider.notifier).state =
                  _MedPrayFrat.meditations,
              isDarkMode: isDarkMode,
            ),
          ),
          Expanded(
            child: _SegmentButton(
              selected: current == _MedPrayFrat.prieres,
              icon: Icons.volunteer_activism,
              label: 'Prières',
              onTap: () => ref.read(_medPrayFratProvider.notifier).state =
                  _MedPrayFrat.prieres,
              isDarkMode: isDarkMode,
            ),
          ),
          Expanded(
            child: _SegmentButton(
              selected: current == _MedPrayFrat.frats,
              icon: Icons.group,
              label: 'Frat',
              onTap: () => ref.read(_medPrayFratProvider.notifier).state =
                  _MedPrayFrat.frats,
              isDarkMode: isDarkMode,
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
    required this.isDarkMode,
  });
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDarkMode;

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
            Icon(
              icon,
              size: 18,
              color: selected
                  ? kOutremer
                  : (isDarkMode
                      ? Colors.grey[500]
                      : _colorWithAlpha(kOutremer, 0.7)),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: leagueSpartanStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? kOutremer
                      : (isDarkMode
                          ? Colors.grey[500]
                          : _colorWithAlpha(kOutremer, 0.8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageHeader extends ConsumerWidget {
  const _PageHeader({required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MedPraySwitch(isDarkMode: isDarkMode),
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
    required this.isDarkMode,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? backgroundColor.withValues(alpha: 0.3)
                : backgroundColor,
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
                  color: kOutremer,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? Colors.grey[400]
                        : _colorWithAlpha(kMarine, 0.7),
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

class _PrayerListCard extends StatelessWidget {
  const _PrayerListCard({
    required this.prayer,
    required this.isDarkMode,
    required this.onTap,
  });

  final Prayer prayer;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode
                  ? Colors.grey[800]!
                  : _colorWithAlpha(kOutremer, 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withValues(alpha: 0.3)
                    : _colorWithAlpha(kOutremer, 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Numéro de la prière
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _colorWithAlpha(kDore, 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${prayer.id}',
                    style: leagueSpartanStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kDore,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Titre et source
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prayer.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.9)
                            : kNoir,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (prayer.source != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        prayer.source!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? Colors.grey[500]
                              : _colorWithAlpha(kNoir, 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Icône de navigation
              Icon(
                Icons.chevron_right,
                color: isDarkMode
                    ? Colors.grey[600]
                    : _colorWithAlpha(kOutremer, 0.6),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- CLASSES ET FONCTIONS UTILITAIRES AU NIVEAU SUPERIEUR ---

class _FratCard extends StatelessWidget {
  const _FratCard({required this.topic, required this.isDarkMode});

  final FratTopic topic;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDarkMode ? Colors.grey[800]! : _colorWithAlpha(kOutremer, 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : _colorWithAlpha(kOutremer, 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _colorWithAlpha(kDore, 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${topic.id}',
                    style: leagueSpartanStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: kDore,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  topic.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : kMarineFonce,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final q in topic.questions)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('— ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      q,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.85)
                            : _colorWithAlpha(kNoir, 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
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

class MeditationDetailPage extends ConsumerWidget {
  const MeditationDetailPage({super.key, required this.meditation});

  final Meditation meditation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeProvider);

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : kBlanc;
    final appBarColor = isDarkMode ? const Color(0xFF121212) : kBlanc;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swipe vers la droite pour retourner
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: kOutremer,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            // En-tête avec titre et sous-titre
            _buildHeader(theme, isDarkMode),
            const SizedBox(height: 32),

            // Sections de la méditation
            ..._buildSections(theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? _colorWithAlpha(kDore, 0.25)
                : _colorWithAlpha(kDore, 0.15),
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
            color: isDarkMode ? Colors.white.withValues(alpha: 0.9) : kOutremer,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          meditation.subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color:
                isDarkMode ? Colors.grey[400] : _colorWithAlpha(kOutremer, 0.8),
            fontStyle: FontStyle.italic,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  List<Widget> _buildSections(ThemeData theme, bool isDarkMode) {
    final widgets = <Widget>[];

    for (int i = 0; i < meditation.sections.length; i++) {
      final section = meditation.sections[i];

      widgets.add(_buildSection(section, theme, isDarkMode));

      if (i < meditation.sections.length - 1) {
        widgets.add(const SizedBox(height: 24));
        widgets.add(_buildDivider(isDarkMode));
        widgets.add(const SizedBox(height: 24));
      }
    }

    return widgets;
  }

  Widget _buildSection(
      MeditationSection section, ThemeData theme, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texte principal
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF2C2C2C)
                : _colorWithAlpha(kOutremer, 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode
                  ? Colors.grey[700]!
                  : _colorWithAlpha(kOutremer, 0.1),
              width: 1,
            ),
          ),
          child: Text(
            section.text,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.85)
                  : _colorWithAlpha(kNoir, 0.85),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        // Points de réflexion
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...section.bullets
              .map((bullet) => _buildBulletPoint(bullet, theme, isDarkMode)),
        ],

        // Prière
        if (section.prayer != null) ...[
          const SizedBox(height: 20),
          _buildPrayer(section.prayer!, theme, isDarkMode),
        ],
      ],
    );
  }

  Widget _buildBulletPoint(String bullet, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1E1E1E)
              : _colorWithAlpha(kMarine, 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isDarkMode ? Colors.grey[800]! : _colorWithAlpha(kMarine, 0.08),
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
                  color: isDarkMode
                      ? Colors.white.withValues(alpha: 0.8)
                      : _colorWithAlpha(kNoir, 0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayer(String prayer, ThemeData theme, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? null
            : LinearGradient(
                colors: [
                  _colorWithAlpha(kDore, 0.1),
                  _colorWithAlpha(kDore, 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDarkMode ? const Color(0xFF2C2C2C) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? _colorWithAlpha(kDore, 0.4)
              : _colorWithAlpha(kDore, 0.2),
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
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.85)
                  : _colorWithAlpha(kNoir, 0.85),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color:
                isDarkMode ? Colors.grey[800] : _colorWithAlpha(kOutremer, 0.2),
          ),
        ),
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
          child: Container(
            height: 1,
            color:
                isDarkMode ? Colors.grey[800] : _colorWithAlpha(kOutremer, 0.2),
          ),
        ),
      ],
    );
  }
}

class PrayerDetailPage extends ConsumerWidget {
  const PrayerDetailPage({super.key, required this.prayer});

  final Prayer prayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeProvider);

    final backgroundColor = isDarkMode ? const Color(0xFF121212) : kBlanc;
    final appBarColor = isDarkMode ? const Color(0xFF121212) : kBlanc;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: kOutremer,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            _buildHeader(theme, isDarkMode),
            const SizedBox(height: 24),
            _buildPrayerBody(theme, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? _colorWithAlpha(kDore, 0.25)
                : _colorWithAlpha(kDore, 0.15),
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
            color: isDarkMode ? Colors.white.withValues(alpha: 0.9) : kOutremer,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        if (prayer.source != null) ...[
          const SizedBox(height: 8),
          Text(
            prayer.source!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDarkMode
                  ? Colors.grey[400]
                  : _colorWithAlpha(kOutremer, 0.8),
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildPrayerBody(ThemeData theme, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF2C2C2C)
            : _colorWithAlpha(kOutremer, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDarkMode ? Colors.grey[700]! : _colorWithAlpha(kOutremer, 0.12),
          width: 1,
        ),
      ),
      child: Text(
        prayer.text,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.5,
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.85)
              : _colorWithAlpha(kNoir, 0.85),
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
