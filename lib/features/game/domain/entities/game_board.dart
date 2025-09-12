import 'tile.dart';

class GameBoard {
  final List<List<Tile?>> tiles;
  final int score;
  final bool isGameOver;

  const GameBoard({
    required this.tiles,
    this.score = 0,
    this.isGameOver = false,
  });

  GameBoard copyWith({
    List<List<Tile?>>? tiles,
    int? score,
    bool? isGameOver,
  }) {
    return GameBoard(
      tiles: tiles ?? this.tiles,
      score: score ?? this.score,
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
}