import '../../domain/entities/game_board.dart';
import '../../domain/entities/direction.dart';
import '../../domain/entities/tile.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/local_game_datasource.dart';
import '../../../../core/constants/game_constants.dart';
import 'dart:math';

class GameRepositoryImpl implements GameRepository {
  final LocalGameDataSource dataSource;
  final Random _random = Random();

  GameRepositoryImpl(this.dataSource);

  @override
  GameBoard getInitialBoard() {
    return GameBoard(
      tiles: List.generate(
        GameConstants.boardSize,
        (index) => List.generate(GameConstants.boardSize, (index) => null),
      ),
    );
  }

  @override
  GameBoard addRandomTile(GameBoard board) {
    final emptyCells = <List<int>>[];
    
    // Trouve toutes les cellules vides
    for (int row = 0; row < GameConstants.boardSize; row++) {
      for (int col = 0; col < GameConstants.boardSize; col++) {
        if (board.tiles[row][col] == null) {
          emptyCells.add([row, col]);
        }
      }
    }

    if (emptyCells.isEmpty) return board;

    // Choisit une cellule vide aléatoire
    final randomCell = emptyCells[_random.nextInt(emptyCells.length)];
    final row = randomCell[0];
    final col = randomCell[1];

    final newTile = _generateRandomTile(row, col);
    
    // Met à jour le plateau
    final newTiles = List.generate(
      GameConstants.boardSize,
      (r) => List.generate(GameConstants.boardSize, (c) => board.tiles[r][c]),
    );
    newTiles[row][col] = newTile;

    return board.copyWith(tiles: newTiles);
  }

  Tile _generateRandomTile(int row, int col) {
    final random = _random.nextDouble();
    
    if (random < GameConstants.bonusTileProbability) {
      final value = _random.nextDouble() < 0.5 ? 2 : 4;
      return Tile(value: value, row: row, col: col, type: TileType.bonus);
    } else if (random < GameConstants.bonusTileProbability + GameConstants.freezeTileProbability) {
      return Tile(
        value: 0, 
        row: row, 
        col: col, 
        type: TileType.freeze,
        freezeUsesRemaining: GameConstants.defaultFreezeUsesRemaining,
      );
    } else if (random < GameConstants.bonusTileProbability + GameConstants.freezeTileProbability + GameConstants.value2Probability) {
      return Tile(value: 2, row: row, col: col);
    } else {
      return Tile(value: 4, row: row, col: col);
    }
  }

  // Implémentez les autres méthodes ici...
  @override
  GameBoard moveTiles(GameBoard board, Direction direction) {
    // Votre logique de mouvement existante
    throw UnimplementedError();
  }

  @override
  bool canMove(GameBoard board, Direction direction) {
    // Votre logique de vérification de mouvement
    throw UnimplementedError();
  }

  @override
  bool isGameOver(GameBoard board) {
    // Votre logique de vérification de fin de jeu
    throw UnimplementedError();
  }

  @override
  void saveGame(GameBoard board) {
    dataSource.saveGameState(board);
  }

  @override
  GameBoard? loadGame() {
    return dataSource.loadGameState();
  }
}