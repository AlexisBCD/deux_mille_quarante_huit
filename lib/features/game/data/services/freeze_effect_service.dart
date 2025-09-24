import '../../domain/entities/game_board.dart';
import '../../domain/entities/game_settings.dart';
import '../../domain/entities/tile.dart';
import '../../domain/entities/direction.dart';

class FreezeEffectService {
  
  GameBoard applyFreezeEffects(GameBoard board, GameSettings settings) {
    if (!settings.hasFreezeTiles) return board;
    
    final newTiles = _copyBoard(board.tiles, settings.boardSize);
    _applyFreezeEffectsToBoard(newTiles, settings.boardSize);
    _reduceAllFreezeCounters(newTiles, settings.boardSize);
    
    return board.copyWith(tiles: newTiles);
  }

  void _applyFreezeEffectsToBoard(List<List<Tile?>> board, int boardSize) {
    final freezeTilesToRemove = <List<int>>[];
    
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        final tile = board[row][col];
        if (tile != null && tile.isFreeze && !tile.isFreezeExhausted) {
          bool hasAffectedSomeone = false;
          
          for (final direction in Direction.values) {
            final delta = direction.delta;
            final newRow = row + delta[0];
            final newCol = col + delta[1];
            
            if (newRow >= 0 && newRow < boardSize && 
                newCol >= 0 && newCol < boardSize) {
              final targetTile = board[newRow][newCol];
              if (targetTile != null && !targetTile.isFrozen && !targetTile.isFreeze) {
                board[newRow][newCol] = targetTile.applyFreeze(turns: 3);
                hasAffectedSomeone = true;
              }
            }
          }
          
          if (hasAffectedSomeone) {
            final updatedTile = tile.reduceFreezeTileUses();
            if (updatedTile.isFreezeExhausted) {
              freezeTilesToRemove.add([row, col]);
            } else {
              board[row][col] = updatedTile;
            }
          }
        }
      }
    }
    
    for (final position in freezeTilesToRemove) {
      board[position[0]][position[1]] = null;
    }
  }

  void _reduceAllFreezeCounters(List<List<Tile?>> board, int boardSize) {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        final tile = board[row][col];
        if (tile != null && tile.isFrozen && tile.freezeRemainingTurns > 0) {
          board[row][col] = tile.copyWith(
            freezeRemainingTurns: tile.freezeRemainingTurns - 1,
          );
        }
      }
    }
  }
  
  List<List<Tile?>> _copyBoard(List<List<Tile?>> board, int boardSize) {
    return List.generate(
      boardSize,
      (r) => List.generate(boardSize, (c) => board[r][c]),
    );
  }
}