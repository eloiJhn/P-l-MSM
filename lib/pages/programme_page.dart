import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models.dart';
import '../providers.dart';
import '../theme.dart';

class ProgrammePage extends ConsumerWidget {
  const ProgrammePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDays = ref.watch(programmeProvider);
    final selectedDayIndex = ref.watch(programmeSelectedDayIndexProvider);

    return asyncDays.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Erreur chargement programme: $err'),
        ),
      ),
      data: (days) => _ProgrammeAgenda(
        days: days,
        selectedIndex: selectedDayIndex,
        onDaySelected: (index) =>
            ref.read(programmeSelectedDayIndexProvider.notifier).state = index,
      ),
    );
  }
}

class _ProgrammeAgenda extends StatelessWidget {
  const _ProgrammeAgenda({
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  final List<ProgrammeDay> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const Center(child: Text('Programme à venir'));
    }

    final safeIndex = selectedIndex.clamp(0, days.length - 1);
    final selectedDay = days[safeIndex];
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        const SizedBox(height: 24),
        _DayPicker(
          days: days,
          selectedIndex: safeIndex,
          onDaySelected: onDaySelected,
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _AgendaCard(key: ValueKey(selectedDay.date), day: selectedDay),
        ),
      ],
    );
  }
}

class _DayPicker extends StatelessWidget {
  const _DayPicker({
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  final List<ProgrammeDay> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final segments = days
        .asMap()
        .entries
        .map(
          (entry) => ButtonSegment<int>(
            value: entry.key,
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.value.label,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDateShort(entry.value.date),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();

    return SegmentedButton<int>(
      segments: segments,
      selected: {selectedIndex},
      onSelectionChanged: (values) {
        if (values.isNotEmpty) {
          onDaySelected(values.first);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.selected)
              ? kMarine
              : _colorWithOpacity(kOutremer, 0.35),
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.selected) ? kBlanc : kMarine,
        ),
        side: WidgetStateProperty.resolveWith<BorderSide?>(
          (states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? kMarine
                : _colorWithOpacity(kMarine, 0.3),
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }

  String _formatDateShort(String originalDate) {
    // Convertit les dates selon l'index du jour
    // Samedi = 11-10-2025, Dimanche = 12-10-2025
    final dayIndex = days.indexWhere((day) => day.date == originalDate);
    if (dayIndex == 0) return '11-10-2025';
    if (dayIndex == 1) return '12-10-2025';
    return originalDate; // fallback
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({super.key, required this.day});

  final ProgrammeDay day;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _colorWithOpacity(kOutremer, 0.25),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            day.entries.length,
            (index) => _AgendaEntry(
              entry: day.entries[index],
              isLast: index == day.entries.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaEntry extends StatelessWidget {
  const _AgendaEntry({required this.entry, required this.isLast});

  final ProgrammeEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final timeStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: kMarine,
    );
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: _colorWithOpacity(theme.colorScheme.onSurface, .7),
    );
    final noteStyle = theme.textTheme.bodySmall?.copyWith(
      color: _colorWithOpacity(theme.colorScheme.onSurface, .6),
      fontStyle: FontStyle.italic,
    );

    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      decoration: BoxDecoration(
        color: kBlanc,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: kMarine, width: 4)),
        boxShadow: [
          BoxShadow(
            color: _colorWithOpacity(kMarine, 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              child: Text(
                entry.time,
                style: timeStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.title, style: titleStyle),
                  if (entry.place != null && entry.place!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(entry.place!, style: subtitleStyle),
                    ),
                  if (entry.notes != null && entry.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(entry.notes!, style: noteStyle),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _colorWithOpacity(Color color, double opacity) {
  final clamped = opacity.clamp(0.0, 1.0);
  return color.withAlpha((clamped * 255).round());
}
