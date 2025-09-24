import 'package:flutter/material.dart';
import '../../../../core/services/audio_service.dart';

class AudioControlWidget extends StatefulWidget {
  const AudioControlWidget({super.key});

  @override
  State<AudioControlWidget> createState() => _AudioControlWidgetState();
}

class _AudioControlWidgetState extends State<AudioControlWidget> {
  // Utiliser le singleton au lieu de créer une nouvelle instance
  AudioService get _audioService => AudioService.instance;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        _audioService.isMusicEnabled ? Icons.volume_up : Icons.volume_off,
        color: Colors.white,
      ),
      onSelected: (value) {
        switch (value) {
          case 'toggle_music':
            _audioService.toggleMusic();
            setState(() {});
            break;
          case 'toggle_sfx':
            _audioService.toggleSfx();
            setState(() {});
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'toggle_music',
          child: Row(
            children: [
              Icon(
                _audioService.isMusicEnabled ? Icons.music_note : Icons.music_off,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(_audioService.isMusicEnabled ? 'Désactiver musique' : 'Activer musique'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'toggle_sfx',
          child: Row(
            children: [
              Icon(
                _audioService.isSfxEnabled ? Icons.volume_up : Icons.volume_off,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(_audioService.isSfxEnabled ? 'Désactiver effets' : 'Activer effets'),
            ],
          ),
        ),
      ],
    );
  }
}