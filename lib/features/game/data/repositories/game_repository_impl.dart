import 'dart:math';
import '../../domain/entities/game_board.dart';
import '../../domain/entities/direction.dart';
import '../../domain/entities/tile.dart';
import '../../domain/entities/game_settings.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/local_game_datasource.dart';

class GameRepositoryImpl implements GameRepository {
  final LocalGameDataSource dataSource;
  final Random _random = Random();

  GameRepositoryImpl(this.dataSource);

  @override
  Future<int> getBestScore() async {
    return await dataSource.getBestScore();
  }

  @override
  Future<void> saveBestScore(int score) async {
    await dataSource.saveBestScore(score);
  }

  @override
  Future<GameBoard> getInitialBoard(GameSettings settings) async {
    final bestScore = await getBestScore();
    return GameBoard(
      tiles: List.generate(
        settings.boardSize,
        (index) => List.generate(settings.boardSize, (index) => null),
      ),
      bestScore: bestScore,
    );
  }

  @override
  GameBoard addRandomTile(GameBoard board, GameSettings settings) {
    final emptyCells = board.getEmptyCells();
    if (emptyCells.isEmpty) return board;

    final randomCell = emptyCells[_random.nextInt(emptyCells.length)];
    final row = randomCell[0];
    final col = randomCell[1];

    final newTile = _generateRandomTile(row, col, settings);
    
    final newTiles = List.generate(
      settings.boardSize,
      (r) => List.generate(settings.boardSize, (c) => board.tiles[r][c]),
    );
    newTiles[row][col] = newTile;

    return board.copyWith(tiles: newTiles);
  }

  @override
  GameBoard moveTiles(GameBoard board, Direction direction, GameSettings settings) {
    final newTiles = _copyBoard(board.tiles, settings.boardSize);
    bool moved = false;
    int scoreGained = 0;

    // Applique l'effet gel aux tuiles touchées par une tuile gel (seulement en mode bonus/malus)
    if (settings.hasFreezeTiles) {
      _applyFreezeEffects(newTiles, settings.boardSize);
    }

    switch (direction) {
      case Direction.left:
        for (int row = 0; row < settings.boardSize; row++) {
          final result = _moveAndMergeRow(newTiles[row], settings);
          newTiles[row] = result.tiles;
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
      case Direction.right:
        for (int row = 0; row < settings.boardSize; row++) {
          final reversed = newTiles[row].reversed.toList();
          final result = _moveAndMergeRow(reversed, settings);
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
          final result = _moveAndMergeRow(column, settings);
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
          final result = _moveAndMergeRow(column, settings);
          for (int row = 0; row < settings.boardSize; row++) {
            newTiles[settings.boardSize - 1 - row][col] = result.tiles[row];
          }
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
    }

    if (moved) {
      if (settings.hasFreezeTiles) {
        _reduceAllFreezeCounters(newTiles, settings.boardSize);
      }
      _updateTilePositions(newTiles, settings.boardSize);
      
      return board.copyWith(
        tiles: newTiles,
        score: board.score + scoreGained,
      );
    }

    return board;
  }

  @override
  bool canMove(GameBoard board, Direction direction, GameSettings settings) {
    final testTiles = _copyBoard(board.tiles, settings.boardSize);
    
    switch (direction) {
      case Direction.left:
        for (int row = 0; row < settings.boardSize; row++) {
          final result = _moveAndMergeRow(testTiles[row], settings);
          if (result.moved) return true;
        }
        break;
      case Direction.right:
        for (int row = 0; row < settings.boardSize; row++) {
          final reversed = testTiles[row].reversed.toList();
          final result = _moveAndMergeRow(reversed, settings);
          if (result.moved) return true;
        }
        break;
      case Direction.up:
        for (int col = 0; col < settings.boardSize; col++) {
          final column = [
            for (int row = 0; row < settings.boardSize; row++) testTiles[row][col]
          ];
          final result = _moveAndMergeRow(column, settings);
          if (result.moved) return true;
        }
        break;
      case Direction.down:
        for (int col = 0; col < settings.boardSize; col++) {
          final column = [
            for (int row = settings.boardSize - 1; row >= 0; row--) testTiles[row][col]
          ];
          final result = _moveAndMergeRow(column, settings);
          if (result.moved) return true;
        }
        break;
    }
    
    return false;
  }

  @override
  bool isGameOver(GameBoard board, GameSettings settings) {
    if (!board.isFull) return false;
    
    // Vérifie si des mouvements sont possibles
    for (final direction in Direction.values) {
      if (canMove(board, direction, settings)) return false;
    }
    
    return true;
  }

  @override
  void saveGame(GameBoard board) {
    dataSource.saveGameState(board);
  }

  @override
  GameBoard? loadGame() {
    return dataSource.loadGameState();
  }

  // Méthodes privées
  Tile _generateRandomTile(int row, int col, GameSettings settings) {
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

  void _applyFreezeEffects(List<List<Tile?>> board, int boardSize) {
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
        if (tile != null && tile.isFrozen) {
          board[row][col] = tile.reduceFreeze();
        }
      }
    }
  }

  _MoveResult _moveAndMergeRow(List<Tile?> tiles, GameSettings settings) {
    final movableTiles = <Tile>[];
    final frozenPositions = <int, Tile>{};
    
    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];
      if (tile != null) {
        if (tile.canMove && !tile.isFreeze) {
          movableTiles.add(tile);
        } else {
          frozenPositions[i] = tile;
        }
      }
    }
    
    final result = <Tile?>[];
    int score = 0;
    bool moved = false;
    
    int i = 0;
    while (i < movableTiles.length) {
      if (i + 1 < movableTiles.length && 
          movableTiles[i].canMergeWith(movableTiles[i + 1])) {
        final mergedValue = movableTiles[i].getMergedValue(movableTiles[i + 1]);
        result.add(Tile(
          value: mergedValue,
          row: movableTiles[i].row,
          col: movableTiles[i].col,
          type: TileType.normal,
        ));
        score += mergedValue;
        i += 2;
        moved = true;
      } else {
        result.add(movableTiles[i]);
        i++;
      }
    }
    
    final finalResult = List<Tile?>.filled(settings.boardSize, null);
    
    frozenPositions.forEach((position, tile) {
      finalResult[position] = tile;
    });
    
    int resultIndex = 0;
    for (int pos = 0; pos < settings.boardSize && resultIndex < result.length; pos++) {
      if (finalResult[pos] == null) {
        finalResult[pos] = result[resultIndex];
        resultIndex++;
      }
    }
    
    if (!moved) {
      for (int j = 0; j < tiles.length; j++) {
        if ((tiles[j] == null) != (finalResult[j] == null) ||
            (tiles[j] != null && finalResult[j] != null && 
             !_tilesEqual(tiles[j]!, finalResult[j]!))) {
          moved = true;
          break;
        }
      }
    }
    
    return _MoveResult(tiles: finalResult, moved: moved, score: score);
  }

  bool _tilesEqual(Tile tile1, Tile tile2) {
    return tile1.value == tile2.value && 
           tile1.type == tile2.type && 
           tile1.freezeRemainingTurns == tile2.freezeRemainingTurns &&
           tile1.freezeUsesRemaining == tile2.freezeUsesRemaining;
  }

  void _updateTilePositions(List<List<Tile?>> board, int boardSize) {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (board[row][col] != null) {
          board[row][col] = board[row][col]!.copyWith(row: row, col: col);
        }
      }
    }
  }

  List<List<Tile?>> _copyBoard(List<List<Tile?>> board, int boardSize) {
    return List.generate(
      boardSize,
      (row) => List.generate(boardSize, (col) => board[row][col]),
    );
  }
}

class _MoveResult {
  final List<Tile?> tiles;
  final bool moved;
  final int score;
  
  _MoveResult({
    required this.tiles,
    required this.moved,
    required this.score,
  });
}