class ProgrammeEntry {
  final String time;
  final String title;
  final String? place;
  final String? notes;

  ProgrammeEntry({required this.time, required this.title, this.place, this.notes});

  factory ProgrammeEntry.fromJson(Map<String, dynamic> json) {
    return ProgrammeEntry(
      time: json['time'] as String,
      title: json['title'] as String,
      place: json['place'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'time': time,
        'title': title,
        if (place != null) 'place': place,
        if (notes != null) 'notes': notes,
      };
}

class ProgrammeDay {
  final String date;
  final String label;
  final List<ProgrammeEntry> entries;

  ProgrammeDay({required this.date, required this.label, required this.entries});

  factory ProgrammeDay.fromJson(Map<String, dynamic> json) {
    final items = (json['entries'] as List<dynamic>? ?? [])
        .map((e) => ProgrammeEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return ProgrammeDay(
      date: json['date'] as String,
      label: json['label'] as String,
      entries: items,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'label': label,
        'entries': entries.map((e) => e.toJson()).toList(),
      };
}

class Chant {
  final int id;
  final String title;
  final List<String> refrain;
  final List<String> verses;

  Chant({required this.id, required this.title, required this.refrain, required this.verses});

  factory Chant.fromJson(Map<String, dynamic> json) {
    // Accept either numeric ids or string ids like "c1"
    final rawId = json['id'];
    int parsedId;
    if (rawId is int) {
      parsedId = rawId;
    } else if (rawId is String) {
      final match = RegExp(r'\d+').firstMatch(rawId);
      parsedId = match != null ? int.parse(match.group(0)!) : 0;
    } else {
      parsedId = 0;
    }

    return Chant(
      id: parsedId,
      title: json['title'] as String,
      refrain: (json['refrain'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      verses: (json['verses'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'refrain': refrain, 'verses': verses};
}

class MeditationSection {
  final String text;
  final List<String> bullets;
  final String? prayer;

  MeditationSection({
    required this.text,
    required this.bullets,
    this.prayer,
  });

  factory MeditationSection.fromJson(Map<String, dynamic> json) {
    return MeditationSection(
      text: json['text'] as String,
      bullets: (json['bullets'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      prayer: json['prayer'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'bullets': bullets,
        if (prayer != null) 'prayer': prayer,
      };
}

class Meditation {
  final int id;
  final String title;
  final String subtitle;
  final List<MeditationSection> sections;

  Meditation({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.sections,
  });

  factory Meditation.fromJson(Map<String, dynamic> json) {
    return Meditation(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((e) => MeditationSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'sections': sections.map((e) => e.toJson()).toList(),
      };
}

class Prayer {
  final int id;
  final String title;
  final String? source; // e.g., auteur/pape
  final String text;

  Prayer({required this.id, required this.title, this.source, required this.text});

  factory Prayer.fromJson(Map<String, dynamic> json) {
    return Prayer(
      id: json['id'] as int,
      title: json['title'] as String,
      source: json['source'] as String?,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        if (source != null) 'source': source,
        'text': text,
      };
}
