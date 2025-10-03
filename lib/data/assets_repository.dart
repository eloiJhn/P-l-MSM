import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'models.dart';

const _programmeAssetPath = 'assets/content/programme.json';
const _chantsAssetPath = 'assets/content/chants.json';
const _meditationsAssetPath = 'assets/content/meditations.json';
const _prayersAssetPath = 'assets/content/prieres.json';

Future<List<ProgrammeDay>> loadProgramme() async {
  final raw = await rootBundle.loadString(_programmeAssetPath);
  final decoded = json.decode(raw) as Map<String, dynamic>;
  final days = (decoded['days'] as List<dynamic>)
      .map((e) => ProgrammeDay.fromJson(e as Map<String, dynamic>))
      .toList();
  return days;
}

Future<List<Chant>> loadChants() async {
  final raw = await rootBundle.loadString(_chantsAssetPath);
  final decoded = json.decode(raw) as List<dynamic>;
  return decoded.map((e) => Chant.fromJson(e as Map<String, dynamic>)).toList();
}

Future<List<Meditation>> loadMeditations() async {
  final raw = await rootBundle.loadString(_meditationsAssetPath);
  final decoded = json.decode(raw) as List<dynamic>;
  return decoded.map((e) => Meditation.fromJson(e as Map<String, dynamic>)).toList();
}

Future<List<Prayer>> loadPrayers() async {
  final raw = await rootBundle.loadString(_prayersAssetPath);
  final decoded = json.decode(raw) as List<dynamic>;
  return decoded.map((e) => Prayer.fromJson(e as Map<String, dynamic>)).toList();
}
