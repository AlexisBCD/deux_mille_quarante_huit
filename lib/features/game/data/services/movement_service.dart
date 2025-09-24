import '../../domain/entities/game_board.dart';
import '../../domain/entities/game_settings.dart';
import '../../domain/entities/tile.dart';
import '../../domain/entities/direction.dart';
import 'board_utils_service.dart';

class MoveResult {
  final List<Tile?> tiles;
  final bool moved;
  final int score;
  
  MoveResult({
    required this.tiles,
    required this.moved,
    required this.score,
  });
}

class MovementService {
  final BoardUtilsService _boardUtilsService;
  
  MovementService(this._boardUtilsService);
  
  GameBoard moveAndMergeTiles(GameBoard board, Direction direction, GameSettings settings) {
    final newTiles = _boardUtilsService.copyBoard(board.tiles, settings.boardSize);
    bool moved = false;
    int scoreGained = 0;

    switch (direction) {
      case Direction.left:
        for (int row = 0; row < settings.boardSize; row++) {
          final result = moveAndMergeRow(newTiles[row], settings);
          newTiles[row] = result.tiles;
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
      case Direction.right:
        for (int row = 0; row < settings.boardSize; row++) {
          final reversed = newTiles[row].reversed.toList();
          final result = moveAndMergeRow(reversed, settings);
          newTiles[row] = result.tiles.reversed.toList();
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
      case Direction.up:
        for (int col = 0; col < settings.boardSize; col++) {
          final column = [
            for (int row = 0; row < settings.boardSize; row++) newTiles[row][col]
          ];
          final result = moveAndMergeRow(column, settings);
          for (int row = 0; row < settings.boardSize; row++) {
            newTiles[row][col] = result.tiles[row];
          }
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
      case Direction.down:
        for (int col = 0; col < settings.boardSize; col++) {
          final column = [
            for (int row = settings.boardSize - 1; row >= 0; row--) newTiles[row][col]
          ];
          final result = moveAndMergeRow(column, settings);
          for (int row = 0; row < settings.boardSize; row++) {
            newTiles[settings.boardSize - 1 - row][col] = result.tiles[row];
          }
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
    }

    if (moved) {
      _boardUtilsService.updateTilePositions(newTiles, settings.boardSize);
      return board.copyWith(
        tiles: newTiles,
        score: board.score + scoreGained,
      );
    }

    return board;
  }
  
  MoveResult moveAndMergeRow(List<Tile?> tiles, GameSettings settings) {
    // Identifier les positions des tuiles gelées et des tuiles de gel
    final frozenPositions = <int, Tile>{};
    final movableTiles = <Tile>[];
    
    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];
      if (tile != null) {
        if (tile.isFrozen || tile.isFreeze) {
          // Les tuiles gelées et les tuiles de gel restent en place
          frozenPositions[i] = tile;
        } else {
          // Les autres tuiles peuvent bouger
          movableTiles.add(tile);
        }
      }
    }
    
    // Fusionner les tuiles mobiles
    final mergedTiles = <Tile>[];
    int score = 0;
    
    int i = 0;
    while (i < movableTiles.length) {
      final current = movableTiles[i];
      
      if (i + 1 < movableTiles.length) {
        final next = movableTiles[i + 1];
        if (current.canMergeWith(next)) {
          final mergedValue = current.getMergedValue(next);
          mergedTiles.add(current.copyWith(
            value: mergedValue,
            type: TileType.normal, // La tuile fusionnée devient normale
          ));
          score += mergedValue;
          i += 2; // Skip next tile as it's merged
        } else {
          mergedTiles.add(current);
          i++;
        }
      } else {
        mergedTiles.add(current);
        i++;
      }
    }
    
    // Créer le résultat final
    final result = List<Tile?>.filled(tiles.length, null);
    
    // Placer d'abord les tuiles gelées à leurs positions fixes
    frozenPositions.forEach((position, tile) {
      result[position] = tile;
    });
    
    // Placer les tuiles mobiles dans les positions disponibles vers la gauche
    int mergedIndex = 0;
    for (int pos = 0; pos < tiles.length && mergedIndex < mergedTiles.length; pos++) {
      if (result[pos] == null) {
        result[pos] = mergedTiles[mergedIndex];
        mergedIndex++;
      }
    }
    
    // Vérifier si quelque chose a bougé
    bool hasMoved = false;
    for (int i = 0; i < tiles.length; i++) {
      if (tiles[i] != result[i]) {
        hasMoved = true;
        break;
      }
    }

    return MoveResult(tiles: result, moved: hasMoved, score: score);
  }
}