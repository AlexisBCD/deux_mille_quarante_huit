
import '../../../home/domain/entities/game_mode.dart';

class GameSettings {
  final GameMode mode;
  final int boardSize;
  final bool hasBonusTiles;
  final bool hasFreezeTiles;
  final double bonusTileProbability;
  final double freezeTileProbability;
  final double value2Probability;

  const GameSettings({
    required this.mode,
    required this.boardSize,
    required this.hasBonusTiles,
    required this.hasFreezeTiles,
    required this.bonusTileProbability,
    required this.freezeTileProbability,
    required this.value2Probability,
  });

  factory GameSettings.fromMode(GameMode mode) {
    switch (mode) {
      case GameMode.classic4x4:
        return const GameSettings(
          mode: GameMode.classic4x4,
          boardSize: 4,
          hasBonusTiles: false,
          hasFreezeTiles: false,
          bonusTileProbability: 0.0,
          freezeTileProbability: 0.0,
          value2Probability: 0.9, // 90% de tuiles 2, 10% de tuiles 4
        );
      case GameMode.bonusMalus4x4:
        return const GameSettings(
          mode: GameMode.bonusMalus4x4,
          boardSize: 4,
          hasBonusTiles: true,
          hasFreezeTiles: true,
          bonusTileProbability: 0.05, // 5%
          freezeTileProbability: 0.03, // 3%
          value2Probability: 0.82, // 82% de tuiles 2, reste pour tuiles 4
        );
      case GameMode.classic5x5:
        return const GameSettings(
          mode: GameMode.classic5x5,
          boardSize: 5,
          hasBonusTiles: false,
          hasFreezeTiles: false,
          bonusTileProbability: 0.0,
          freezeTileProbability: 0.0,
          value2Probability: 0.9,
        );
      case GameMode.hardcore4x4:
        return const GameSettings(
          mode: GameMode.hardcore4x4,
          boardSize: 4,
          hasBonusTiles: false,
          hasFreezeTiles: false,
          bonusTileProbability: 0.0,
          freezeTileProbability: 0.0,
          value2Probability: 0.7, // Plus de tuiles 4 = plus difficile
        );
    }
  }
}