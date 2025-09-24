enum GameMode {
  classic4x4('4×4 Classique', '🌱', 'Le jeu 2048 traditionnel'),
  bonusMalus4x4('4×4 Bonus/Malus', '🌟', 'Avec tuiles spéciales et effets de gel'),
  classic5x5('5×5 Classique', '🌳', 'Version étendue sur grille 5×5'),
  hardcore4x4('4×4 Hardcore', '🔥', 'Difficulté augmentée');

  const GameMode(this.displayName, this.emoji, this.description);

  final String displayName;
  final String emoji;
  final String description;

  bool get isAvailable {
    switch (this) {
      case GameMode.classic4x4:
      case GameMode.bonusMalus4x4:
      case GameMode.classic5x5:
        return true; // Modes disponibles
      case GameMode.hardcore4x4:
        return false; // Bientôt disponible
    }
  }
}