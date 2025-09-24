import 'dart:math';
import '../../domain/entities/tile.dart';
import '../../domain/entities/game_settings.dart';

class TileGenerationService {
  final Random _random = Random();

  Tile generateRandomTile(int row, int col, GameSettings settings) {
    final random = _random.nextDouble();
    
    if (settings.hasBonusTiles && random < settings.bonusTileProbability) {
      final value = _random.nextDouble() < 0.5 ? 2 : 4;
      return Tile(value: value, row: row, col: col, type: TileType.bonus);
    } else if (settings.hasFreezeTiles && 
               random < settings.bonusTileProbability + settings.freezeTileProbability) {
      return Tile(
        value: 0, 
        row: row, 
        col: col, 
        type: TileType.freeze,
        freezeUsesRemaining: 3,
      );
    } else if (random < settings.bonusTileProbability + settings.freezeTileProbability + settings.value2Probability) {
      return Tile(value: 2, row: row, col: col);
    } else {
      return Tile(value: 4, row: row, col: col);
    }
  }
}