import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/tile.dart';
import '../domain/entities/direction.dart';

class GameBoardState {
  final List<List<Tile?>> board;
  final int score;
  final bool gameOver;

  const GameBoardState({
    required this.board,
    this.score = 0,
    this.gameOver = false,
  });

  GameBoardState copyWith({
    List<List<Tile?>>? board,
    int? score,
    bool? gameOver,
  }) {
    return GameBoardState(
      board: board ?? this.board,
      score: score ?? this.score,
      gameOver: gameOver ?? this.gameOver,
    );
  }
}

class GameBoardCubit extends Cubit<GameBoardState> {
  static const int boardSize = 4;
  final Random _random = Random();

  GameBoardCubit() : super(_initialState()) {
    _addRandomTile();
    _addRandomTile();
  }

  // Initialise un plateau 4x4 vide
  static GameBoardState _initialState() {
    return GameBoardState(
      board: List.generate(
        boardSize,
        (index) => List.generate(boardSize, (index) => null),
      ),
    );
  }

  // Ajoute une tuile aléatoire (2, 4, bonus ou gel) à une position vide
  void _addRandomTile() {
    final emptyCells = <List<int>>[];
    
    // Trouve toutes les cellules vides
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (state.board[row][col] == null) {
          emptyCells.add([row, col]);
        }
      }
    }

    if (emptyCells.isEmpty) return;

    // Choisit une cellule vide aléatoire
    final randomCell = emptyCells[_random.nextInt(emptyCells.length)];
    final row = randomCell[0];
    final col = randomCell[1];

    Tile newTile;
    final random = _random.nextDouble();
    
    if (random < 0.05) {
      // 5% chance d'avoir une tuile bonus
      final value = _random.nextDouble() < 0.5 ? 2 : 4;
      newTile = Tile(value: value, row: row, col: col, type: TileType.bonus);
    } else if (random < 0.08) {
      // 3% chance d'avoir une tuile gel (avec 3 utilisations)
      newTile = Tile(value: 0, row: row, col: col, type: TileType.freeze, freezeUsesRemaining: 3);
    } else if (random < 0.93) {
      // 85% chance d'avoir 2
      newTile = Tile(value: 2, row: row, col: col);
    } else {
      // 7% chance d'avoir 4
      newTile = Tile(value: 4, row: row, col: col);
    }

    // Met à jour le plateau
    final newBoard = List.generate(
      boardSize,
      (r) => List.generate(boardSize, (c) => state.board[r][c]),
    );
    newBoard[row][col] = newTile;

    emit(state.copyWith(board: newBoard));
  }

  // Effectue un mouvement dans la direction donnée
  void move(Direction direction) {
    if (state.gameOver) return;

    final newBoard = _copyBoard(state.board);
    bool moved = false;
    int scoreGained = 0;

    // Applique l'effet gel aux tuiles touchées par une tuile gel
    _applyFreezeEffects(newBoard);

    switch (direction) {
      case Direction.left:
        for (int row = 0; row < boardSize; row++) {
          final result = _moveAndMergeRow(newBoard[row]);
          newBoard[row] = result.tiles;
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
      case Direction.right:
        for (int row = 0; row < boardSize; row++) {
          final reversed = newBoard[row].reversed.toList();
          final result = _moveAndMergeRow(reversed);
          newBoard[row] = result.tiles.reversed.toList();
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
      case Direction.up:
        for (int col = 0; col < boardSize; col++) {
          final column = [
            for (int row = 0; row < boardSize; row++) newBoard[row][col]
          ];
          final result = _moveAndMergeRow(column);
          for (int row = 0; row < boardSize; row++) {
            newBoard[row][col] = result.tiles[row];
          }
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
      case Direction.down:
        for (int col = 0; col < boardSize; col++) {
          final column = [
            for (int row = boardSize - 1; row >= 0; row--) newBoard[row][col]
          ];
          final result = _moveAndMergeRow(column);
          for (int row = 0; row < boardSize; row++) {
            newBoard[boardSize - 1 - row][col] = result.tiles[row];
          }
          if (result.moved) moved = true;
          scoreGained += result.score;
        }
        break;
    }

    if (moved) {
      // Réduit le gel de toutes les tuiles d'un tour
      _reduceAllFreezeCounters(newBoard);
      
      // Met à jour les positions des tuiles
      _updateTilePositions(newBoard);
      
      emit(state.copyWith(
        board: newBoard,
        score: state.score + scoreGained,
      ));
      
      _addRandomTile();
      
      // Vérifie si le jeu est terminé
      if (_isGameOver()) {
        emit(state.copyWith(gameOver: true));
      }
    }
  }

  // Applique l'effet gel aux tuiles adjacentes et réduit les utilisations
  void _applyFreezeEffects(List<List<Tile?>> board) {
    final freezeTilesToRemove = <List<int>>[];
    
    // Trouve toutes les tuiles gel
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        final tile = board[row][col];
        if (tile != null && tile.isFreeze && !tile.isFreezeExhausted) {
          bool hasAffectedSomeone = false;
          
          // Applique l'effet gel aux tuiles adjacentes
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
          
          // Réduit les utilisations si elle a affecté quelqu'un
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
    
    // Supprime les tuiles gel épuisées
    for (final position in freezeTilesToRemove) {
      board[position[0]][position[1]] = null;
    }
  }

  // Réduit les compteurs de gel de toutes les tuiles
  void _reduceAllFreezeCounters(List<List<Tile?>> board) {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        final tile = board[row][col];
        if (tile != null && tile.isFrozen) {
          board[row][col] = tile.reduceFreeze();
        }
      }
    }
  }

  // Déplace et fusionne une ligne/colonne (mise à jour pour les tuiles gelées)
  _MoveResult _moveAndMergeRow(List<Tile?> tiles) {
    // Sépare les tuiles mobiles des tuiles gelées
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
    
    // Traite les fusions et mouvements des tuiles mobiles
    final result = <Tile?>[];
    int score = 0;
    bool moved = false;
    
    int i = 0;
    while (i < movableTiles.length) {
      if (i + 1 < movableTiles.length && 
          movableTiles[i].canMergeWith(movableTiles[i + 1])) {
        // Fusion de deux tuiles
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
    
    // Reconstitue la ligne avec les tuiles gelées à leur position
    final finalResult = List<Tile?>.filled(boardSize, null);
    
    // Place les tuiles gelées à leur position d'origine
    frozenPositions.forEach((position, tile) {
      finalResult[position] = tile;
    });
    
    // Place les tuiles mobiles dans les espaces libres
    int resultIndex = 0;
    for (int pos = 0; pos < boardSize && resultIndex < result.length; pos++) {
      if (finalResult[pos] == null) {
        finalResult[pos] = result[resultIndex];
        resultIndex++;
      }
    }
    
    // Vérifie si quelque chose a bougé
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

  // Compare deux tuiles
  bool _tilesEqual(Tile tile1, Tile tile2) {
    return tile1.value == tile2.value && 
           tile1.type == tile2.type && 
           tile1.freezeRemainingTurns == tile2.freezeRemainingTurns &&
           tile1.freezeUsesRemaining == tile2.freezeUsesRemaining;
  }

  // Met à jour les positions des tuiles après un mouvement
  void _updateTilePositions(List<List<Tile?>> board) {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (board[row][col] != null) {
          board[row][col] = board[row][col]!.copyWith(row: row, col: col);
        }
      }
    }
  }

  // Copie le plateau
  List<List<Tile?>> _copyBoard(List<List<Tile?>> board) {
    return List.generate(
      boardSize,
      (row) => List.generate(boardSize, (col) => board[row][col]),
    );
  }

  // Vérifie si le jeu est terminé (mise à jour pour les tuiles bonus et gelées)
  bool _isGameOver() {
    // S'il y a encore des cases vides, le jeu continue
    if (!isBoardFull) return false;
    
    // Vérifie s'il y a encore des mouvements possibles
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        final currentTile = state.board[row][col]!;
        
        // Vérifie les voisins horizontaux et verticaux
        for (final direction in Direction.values) {
          final delta = direction.delta;
          final newRow = row + delta[0];
          final newCol = col + delta[1];
          
          if (newRow >= 0 && newRow < boardSize && 
              newCol >= 0 && newCol < boardSize) {
            final neighborTile = state.board[newRow][newCol];
            if (neighborTile != null && currentTile.canMergeWith(neighborTile)) {
              return false; // Fusion possible
            }
          }
        }
      }
    }
    
    return true; // Aucun mouvement possible
  }

  // Vérifie si un mouvement est possible dans une direction
  bool canMove(Direction direction) {
    if (state.gameOver) return false;
    
    final testBoard = _copyBoard(state.board);
    bool canMove = false;
    
    switch (direction) {
      case Direction.left:
        for (int row = 0; row < boardSize; row++) {
          final result = _moveAndMergeRow(testBoard[row]);
          if (result.moved) canMove = true;
        }
        break;
      case Direction.right:
        for (int row = 0; row < boardSize; row++) {
          final reversed = testBoard[row].reversed.toList();
          final result = _moveAndMergeRow(reversed);
          if (result.moved) canMove = true;
        }
        break;
      case Direction.up:
        for (int col = 0; col < boardSize; col++) {
          final column = [
            for (int row = 0; row < boardSize; row++) testBoard[row][col]
          ];
          final result = _moveAndMergeRow(column);
          if (result.moved) canMove = true;
        }
        break;
      case Direction.down:
        for (int col = 0; col < boardSize; col++) {
          final column = [
            for (int row = boardSize - 1; row >= 0; row--) testBoard[row][col]
          ];
          final result = _moveAndMergeRow(column);
          if (result.moved) canMove = true;
        }
        break;
    }
    
    return canMove;
  }

  // Redémarre le jeu
  void resetGame() {
    emit(_initialState());
    _addRandomTile();
    _addRandomTile();
  }

  // Vérifie si le plateau est plein
  bool get isBoardFull {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (state.board[row][col] == null) {
          return false;
        }
      }
    }
    return true;
  }

  // Obtient une tuile à une position donnée
  Tile? getTileAt(int row, int col) {
    if (row < 0 || row >= boardSize || col < 0 || col >= boardSize) {
      return null;
    }
    return state.board[row][col];
  }
}

// Classe utilitaire pour les résultats de mouvement
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