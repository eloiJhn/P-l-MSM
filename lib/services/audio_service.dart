import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Service pour gérer la lecture audio des chants
/// Utilise just_audio pour une lecture native iOS avec support background
class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  int? _currentChantId;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  int? get currentChantId => _currentChantId;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;

  /// Initialise le service et écoute les changements d'état
  Future<void> init() async {
    // Écoute les changements de position
    _player.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    // Écoute les changements de durée
    _player.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    // Écoute les changements d'état de lecture
    _player.playingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });

    // Écoute la fin de la lecture
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        _position = Duration.zero;
        notifyListeners();
      }
    });
  }

  /// Charge et lit un chant audio
  /// @param chantId L'ID du chant à lire
  /// @param title Le titre du chant (pour les métadonnées)
  Future<void> playChant(int chantId, String title) async {
    try {
      // Vérifie si un fichier audio existe pour ce chant
      final audioPath = 'assets/audio/chant_$chantId.mp3';

      // Charge l'audio depuis les assets
      await _player.setAsset(audioPath);

      // Configure les métadonnées pour l'affichage iOS (Control Center, Lock Screen)
      // Note: just_audio gère automatiquement les métadonnées avec audio_service

      _currentChantId = chantId;

      // Lance la lecture
      await _player.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lecture audio chant $chantId: $e');
      rethrow;
    }
  }

  /// Met en pause la lecture
  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  /// Reprend la lecture
  Future<void> resume() async {
    await _player.play();
    _isPlaying = true;
    notifyListeners();
  }

  /// Arrête complètement la lecture
  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
    _currentChantId = null;
    _position = Duration.zero;
    notifyListeners();
  }

  /// Change la position de lecture
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Nettoie les ressources
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// Vérifie si un audio existe pour un chant donné
  /// Note: Dans un cas réel, vous devriez vérifier l'existence du fichier
  bool hasAudio(int chantId) {
    // Pour l'instant, on suppose que les chants 1-10 ont un audio
    // Vous pouvez ajuster selon vos fichiers audio disponibles
    return chantId >= 1 && chantId <= 10;
  }
}
