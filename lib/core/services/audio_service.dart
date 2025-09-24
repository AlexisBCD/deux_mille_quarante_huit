import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  static AudioService get instance => _instance; // Getter manquant pour le singleton
  AudioService._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  Future<void> initialize() async {
    // Configuration du lecteur de musique de fond
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.setVolume(0.3); // Volume plus bas pour la musique de fond
    
    // Configuration du lecteur d'effets sonores
    await _effectPlayer.setVolume(0.7);
    
    print('🎵 Service audio initialisé');
  }

  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    
    try {
      await _backgroundPlayer.play(AssetSource('audio/background_music.mp3'));
      print('🎵 Musique d\'ambiance démarrée');
    } catch (e) {
      print('Erreur lors de la lecture de la musique: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    try {
      await _backgroundPlayer.stop();
      print('🎵 Musique d\'ambiance arrêtée');
    } catch (e) {
      print('Erreur lors de l\'arrêt de la musique: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    try {
      await _backgroundPlayer.pause();
    } catch (e) {
      print('Erreur lors de la pause de la musique: $e');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    
    try {
      await _backgroundPlayer.resume();
    } catch (e) {
      print('Erreur lors de la reprise de la musique: $e');
    }
  }

  Future<void> playMoveSound() async {
    if (!_isSfxEnabled) return;
    
    try {
      await _effectPlayer.play(AssetSource('audio/move_sound.mp3'));
    } catch (e) {
      print('Erreur lors de la lecture du son de mouvement: $e');
    }
  }

  Future<void> playMergeSound() async {
    if (!_isSfxEnabled) return;
    
    try {
      await _effectPlayer.play(AssetSource('audio/merge_sound.mp3'));
    } catch (e) {
      print('Erreur lors de la lecture du son de fusion: $e');
    }
  }

  Future<void> playGameOverSound() async {
    if (!_isSfxEnabled) return;
    
    try {
      await _effectPlayer.play(AssetSource('audio/game_over_sound.mp3'));
    } catch (e) {
      print('Erreur lors de la lecture du son de fin de partie: $e');
    }
  }

  void setMusicEnabled(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  void setSfxEnabled(bool enabled) {
    _isSfxEnabled = enabled;
  }

  // Méthodes toggle manquantes
  void toggleMusic() {
    setMusicEnabled(!_isMusicEnabled);
  }

  void toggleSfx() {
    setSfxEnabled(!_isSfxEnabled);
  }

  void setMusicVolume(double volume) {
    _backgroundPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  void setSfxVolume(double volume) {
    _effectPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> dispose() async {
    await _backgroundPlayer.dispose();
    await _effectPlayer.dispose();
  }
}