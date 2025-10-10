import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models.dart';
import '../providers.dart';
import '../theme.dart';

class ChantsPage extends ConsumerStatefulWidget {
  const ChantsPage({super.key});

  @override
  ConsumerState<ChantsPage> createState() => _ChantsPageState();
}

class _ChantsPageState extends ConsumerState<ChantsPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(chantsQueryProvider);
    _controller = TextEditingController(text: initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncChants = ref.watch(chantsProvider);
    final query = ref.watch(chantsQueryProvider);
    final showOnlyFavorites = ref.watch(showOnlyFavoritesProvider);
    final isDarkMode = ref.watch(themeProvider);

    return asyncChants.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Erreur chargement chants: $err'),
        ),
      ),
      data: (chants) {
        final sorted = [...chants]..sort((a, b) => a.id.compareTo(b.id));
        final filtered = _filterChants(sorted, query, showOnlyFavorites);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _ChantSearchField(
                    controller: _controller,
                    query: query,
                    onChanged: (value) =>
                        ref.read(chantsQueryProvider.notifier).state = value,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  _FavoritesFilter(
                    showOnlyFavorites: showOnlyFavorites,
                    onChanged: (value) => ref
                        .read(showOnlyFavoritesProvider.notifier)
                        .state = value,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  _ResultBadge(
                    count: filtered.length,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final chant = filtered[index];
                  return _ChantListCard(
                    chant: chant,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => ChantDetailPage(chant: chant),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Chant> _filterChants(
      List<Chant> chants, String query, bool showOnlyFavorites) {
    List<Chant> result = chants;

    // Filtre par favoris si activé
    if (showOnlyFavorites) {
      final favoriteIds = getFavoriteChantIds();
      result = result.where((c) => favoriteIds.contains(c.id)).toList();
    }

    // Filtre par texte de recherche
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      final numberMatch = RegExp(r'\d+').firstMatch(q);
      final numericQuery =
          numberMatch != null ? int.tryParse(numberMatch.group(0)!) : null;
      result = result.where((c) {
        final titleMatch = c.title.toLowerCase().contains(q);
        final idMatch = numericQuery != null
            ? c.id == numericQuery
            : c.id.toString().contains(q);
        return titleMatch || idMatch;
      }).toList();
    }

    return result;
  }
}

class _ChantSearchField extends StatelessWidget {
  const _ChantSearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.isDarkMode,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: isDarkMode ? Colors.white.withValues(alpha: 0.9) : null,
      ),
      decoration: InputDecoration(
        hintText: 'Numéro ou titre du chant',
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey[500] : null,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDarkMode ? Colors.grey[400] : null,
        ),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: isDarkMode ? Colors.grey[400] : null,
                ),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: isDarkMode
            ? const Color(0xFF2C2C2C)
            : _colorWithAlpha(kOutremer, 0.18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color:
                isDarkMode ? Colors.grey[700]! : _colorWithAlpha(kMarineFonce, 0.25),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color:
                isDarkMode ? Colors.grey[700]! : _colorWithAlpha(kMarineFonce, 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDarkMode ? kOutremer.withValues(alpha: 0.6) : kOutremer,
            width: 1.4,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({
    required this.count,
    required this.isDarkMode,
  });

  final int count;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF2C2C2C)
                : _colorWithAlpha(kMarineFonce, 0.1),
            borderRadius: BorderRadius.circular(12),
            border: isDarkMode
                ? Border.all(color: Colors.grey[700]!, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                Icons.library_music,
                size: 16,
                color: isDarkMode ? const Color(0xFF81A3C1) : kOutremer,
              ),
              const SizedBox(width: 6),
              Text(
                '$count résultat${count > 1 ? 's' : ''}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: kOutremer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FavoritesFilter extends StatelessWidget {
  const _FavoritesFilter({
    required this.showOnlyFavorites,
    required this.onChanged,
    required this.isDarkMode,
  });

  final bool showOnlyFavorites;
  final ValueChanged<bool> onChanged;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment<bool>(
                value: false,
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.library_music, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Tous',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Favoris',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            selected: {showOnlyFavorites},
            onSelectionChanged: (values) {
              if (values.isNotEmpty) {
                onChanged(values.first);
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return isDarkMode ? const Color(0xFF2C2C2C) : kOutremer;
                  }
                  return isDarkMode
                      ? Colors.grey[800]
                      : _colorWithAlpha(kOutremer, 0.25);
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return isDarkMode ? Colors.white.withValues(alpha: 0.9) : kBlanc;
                  }
                  return kOutremer;
                },
              ),
              side: WidgetStateProperty.resolveWith<BorderSide?>(
                (states) => BorderSide(
                  color: states.contains(WidgetState.selected)
                      ? (isDarkMode ? Colors.grey[700]! : kMarineFonce)
                      : (isDarkMode
                          ? Colors.grey[700]!
                          : _colorWithAlpha(kMarineFonce, 0.3)),
                ),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChantListCard extends ConsumerWidget {
  const _ChantListCard({
    required this.chant,
    required this.isDarkMode,
    required this.onTap,
  });

  final Chant chant;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favAsync = ref.watch(isFavoriteProvider(chant.id));
    final isFav = favAsync.value ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
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
                // Numéro du chant
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _colorWithAlpha(kOutremer, 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      chant.id.toString().padLeft(2, '0'),
                      style: leagueSpartanStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kOutremer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Titre du chant
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chant.title,
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
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Bouton favori
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 24,
                  ),
                  color: isFav ? kDore : (isDarkMode ? Colors.grey[600] : _colorWithAlpha(kOutremer, 0.6)),
                  onPressed: () => toggleFavorite(chant.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChantDetailPage extends ConsumerWidget {
  const ChantDetailPage({super.key, required this.chant});

  final Chant chant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favAsync = ref.watch(isFavoriteProvider(chant.id));
    final isFav = favAsync.value ?? false;
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
          title: Text(
            'Chant ${chant.id.toString().padLeft(2, '0')}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: kOutremer,
            ),
          ),
          actions: [
            IconButton(
              tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? kDore : kOutremer,
              ),
              onPressed: () => toggleFavorite(chant.id),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            // Titre du chant centré
            Center(
              child: Text(
                chant.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: kOutremer,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // Organisation: Refrain puis alternance couplet-refrain
            ..._buildChantContent(isDarkMode),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChantContent(bool isDarkMode) {
    final widgets = <Widget>[];

    // Si on a refrain et couplets, on fait l'alternance
    if (chant.refrain.isNotEmpty && chant.verses.isNotEmpty) {
      // D'abord le refrain
      widgets.add(_buildRefrainText(isDarkMode));
      widgets.add(const SizedBox(height: 32));

      // Puis alternance couplet-refrain
      for (int i = 0; i < chant.verses.length; i++) {
        widgets.add(_buildVerseText(i + 1, chant.verses[i], isDarkMode));
        widgets.add(const SizedBox(height: 24));

        // Refrain après chaque couplet
        widgets.add(_buildRefrainText(isDarkMode));
        if (i < chant.verses.length - 1) {
          widgets.add(const SizedBox(height: 32));
        }
      }
    }
    // Si on a seulement le refrain
    else if (chant.refrain.isNotEmpty) {
      widgets.add(_buildRefrainText(isDarkMode));
    }
    // Si on a seulement les couplets
    else if (chant.verses.isNotEmpty) {
      for (int i = 0; i < chant.verses.length; i++) {
        widgets.add(_buildVerseText(i + 1, chant.verses[i], isDarkMode));
        if (i < chant.verses.length - 1) {
          widgets.add(const SizedBox(height: 24));
        }
      }
    }
    // Si on n'a rien
    else {
      widgets.add(_buildEmptyText(isDarkMode));
    }

    return widgets;
  }

  Widget _buildRefrainText(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refrain',
          style: leagueSpartanStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDore,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 12),
        ...chant.refrain.map((line) => _buildRefrainLine(line, isDarkMode)),
      ],
    );
  }

  Widget _buildVerseText(int number, String verse, bool isDarkMode) {
    final lines = verse.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: leagueSpartanStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDarkMode ? const Color(0xFF81A3C1) : kMarineFonce,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 12),
        ...lines.map((line) => _buildLyricLine(line, isDarkMode)),
      ],
    );
  }

  Widget _buildRefrainLine(String line, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        line,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          fontWeight: FontWeight.w700, // Gras pour le refrain
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.85)
              : _colorWithAlpha(kNoir, 0.85),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildLyricLine(String line, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        line,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: isDarkMode
              ? Colors.white.withValues(alpha: 0.85)
              : _colorWithAlpha(kNoir, 0.85),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildEmptyText(bool isDarkMode) {
    return Center(
      child: Text(
        'Paroles à venir',
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: isDarkMode ? Colors.grey[500] : _colorWithAlpha(kMarineFonce, 0.6),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

Color _colorWithAlpha(Color color, double opacity) {
  final clamped = opacity.clamp(0.0, 1.0);
  return color.withAlpha((clamped * 255).round());
}
