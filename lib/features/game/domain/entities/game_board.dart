import 'tile.dart';

class GameBoard {
  final List<List<Tile?>> tiles;
  final int score;
  final int bestScore;
  final bool isGameOver;

  const GameBoard({
    required this.tiles,
    this.score = 0,
    this.bestScore = 0,
    this.isGameOver = false,
  });

  GameBoard copyWith({
    List<List<Tile?>>? tiles,
    int? score,
    int? bestScore,
    bool? isGameOver,
  }) {
    return GameBoard(
      tiles: tiles ?? this.tiles,
      score: score ?? this.score,
      bestScore: bestScore ?? this.bestScore,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }

  bool get isFull {
    for (final row in tiles) {
      for (final tile in row) {
        if (tile == null) return false;
      }
    }
    return true;
  }

  Tile? getTileAt(int row, int col) {
    if (row < 0 || row >= tiles.length || col < 0 || col >= tiles[0].length) {
      return null;
    }
    return tiles[row][col];
  }

  List<List<int>> getEmptyCells() {
    final emptyCells = <List<int>>[];
    for (int row = 0; row < tiles.length; row++) {
      for (int col = 0; col < tiles[0].length; col++) {
        if (tiles[row][col] == null) {
          emptyCells.add([row, col]);
        }
      }
    }
    return emptyCells;
  }
}