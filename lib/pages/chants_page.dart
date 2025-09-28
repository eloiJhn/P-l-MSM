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
        final theme = Theme.of(context);

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
                  ),
                  const SizedBox(height: 16),
                  _FavoritesFilter(
                    showOnlyFavorites: showOnlyFavorites,
                    onChanged: (value) => ref
                        .read(showOnlyFavoritesProvider.notifier)
                        .state = value,
                  ),
                  const SizedBox(height: 12),
                  _ResultBadge(count: filtered.length),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final chant = filtered[index];
                  return _ChantGridCard(
                    chant: chant,
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
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Numéro ou titre du chant',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: query.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        filled: true,
        fillColor: _colorWithAlpha(kOutremer, 0.18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _colorWithAlpha(kMarine, 0.25)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _colorWithAlpha(kMarine, 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: kMarine, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _colorWithAlpha(kMarine, 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.library_music, size: 16, color: kMarine),
              const SizedBox(width: 6),
              Text(
                '$count résultat${count > 1 ? 's' : ''}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: kMarine,
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
  });

  final bool showOnlyFavorites;
  final ValueChanged<bool> onChanged;

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
                (states) => states.contains(WidgetState.selected)
                    ? kMarine
                    : _colorWithAlpha(kOutremer, 0.25),
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                (states) =>
                    states.contains(WidgetState.selected) ? kBlanc : kMarine,
              ),
              side: WidgetStateProperty.resolveWith<BorderSide?>(
                (states) => BorderSide(
                  color: states.contains(WidgetState.selected)
                      ? kMarine
                      : _colorWithAlpha(kMarine, 0.3),
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

class _ChantGridCard extends ConsumerWidget {
  const _ChantGridCard({required this.chant, required this.onTap});

  final Chant chant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favAsync = ref.watch(isFavoriteProvider(chant.id));
    final isFav = favAsync.value ?? false;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _colorWithAlpha(kMarine, 0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Image d'arrière-plan
                Positioned.fill(
                  child: _getChantImage(chant.id),
                ),
                // Overlay léger uniquement en bas pour la lisibilité du titre
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          _colorWithAlpha(kMarine, 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                // Numéro en haut à gauche
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _colorWithAlpha(kBlanc, 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chant.id.toString().padLeft(2, '0'),
                      style: leagueSpartanStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kMarine,
                      ),
                    ),
                  ),
                ),
                // Bouton favori en haut à droite
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _colorWithAlpha(kBlanc, 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                      ),
                      color: isFav ? kDore : kBlanc,
                      onPressed: () => toggleFavorite(chant.id),
                    ),
                  ),
                ),
                // Titre en bas
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        chant.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: kBlanc,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              offset: const Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: kMarine.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getChantImage(int chantId) {
    // Mapping des noms de fichiers selon ce qui existe dans le dossier
    String getImagePath(int id) {
      switch (id) {
        case 8:
          return 'assets/images/8jpg.jpg'; // Nom spécial pour le fichier 8
        case 11:
          return 'assets/images/11.jpeg';
        case 13:
          return 'assets/images/13.jpeg';
        default:
          return 'assets/images/$id.jpg';
      }
    }

    try {
      return Image.asset(
        getImagePath(chantId),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Image de fallback avec gradient si l'image n'existe pas
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _colorWithAlpha(kOutremer, 0.6),
                  _colorWithAlpha(kMarine, 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          );
        },
      );
    } catch (e) {
      // Image de fallback en cas d'erreur
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _colorWithAlpha(kOutremer, 0.6),
              _colorWithAlpha(kMarine, 0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      );
    }
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
          title: Text(
            'Chant ${chant.id.toString().padLeft(2, '0')}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: kMarine,
            ),
          ),
          actions: [
            IconButton(
              tooltip: isFav ? 'Retirer des favoris' : 'Ajouter aux favoris',
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? kDore : kMarine,
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
                  color: kMarine,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            // Organisation: Refrain puis alternance couplet-refrain
            ..._buildChantContent(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChantContent() {
    final widgets = <Widget>[];

    // Si on a refrain et couplets, on fait l'alternance
    if (chant.refrain.isNotEmpty && chant.verses.isNotEmpty) {
      // D'abord le refrain
      widgets.add(_buildRefrainText());
      widgets.add(const SizedBox(height: 32));

      // Puis alternance couplet-refrain
      for (int i = 0; i < chant.verses.length; i++) {
        widgets.add(_buildVerseText(i + 1, chant.verses[i]));
        widgets.add(const SizedBox(height: 24));

        // Refrain après chaque couplet
        widgets.add(_buildRefrainText());
        if (i < chant.verses.length - 1) {
          widgets.add(const SizedBox(height: 32));
        }
      }
    }
    // Si on a seulement le refrain
    else if (chant.refrain.isNotEmpty) {
      widgets.add(_buildRefrainText());
    }
    // Si on a seulement les couplets
    else if (chant.verses.isNotEmpty) {
      for (int i = 0; i < chant.verses.length; i++) {
        widgets.add(_buildVerseText(i + 1, chant.verses[i]));
        if (i < chant.verses.length - 1) {
          widgets.add(const SizedBox(height: 24));
        }
      }
    }
    // Si on n'a rien
    else {
      widgets.add(_buildEmptyText());
    }

    return widgets;
  }

  Widget _buildRefrainText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Refrain',
          style: leagueSpartanStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDore,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        ...chant.refrain.map((line) => _buildLyricLine(line)),
      ],
    );
  }

  Widget _buildVerseText(int number, String verse) {
    final lines = verse.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$number.',
          style: leagueSpartanStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kMarine,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        ...lines.map((line) => _buildLyricLine(line)),
      ],
    );
  }

  Widget _buildLyricLine(String line) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        line,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: _colorWithAlpha(kNoir, 0.85),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmptyText() {
    return Center(
      child: Text(
        'Paroles à venir',
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: _colorWithAlpha(kMarine, 0.6),
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
