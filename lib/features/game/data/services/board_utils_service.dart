import 'dart:math';
import '../../domain/entities/tile.dart';

class BoardUtilsService {
  static final Random _random = Random();

  List<List<Tile?>> copyBoard(List<List<Tile?>> board, int boardSize) {
    return List.generate(
      boardSize,
      (row) => List.generate(boardSize, (col) => board[row][col]),
    );
  }

  void updateTilePositions(List<List<Tile?>> board, int boardSize) {
    for (int row = 0; row < boardSize; row++) {
      for (int col = 0; col < boardSize; col++) {
        if (board[row][col] != null) {
          board[row][col] = board[row][col]!.copyWith(row: row, col: col);
        }
      }
    }
  }

  List<int> getRandomEmptyCell(List<List<int>> emptyCells) {
    if (emptyCells.isEmpty) throw Exception('No empty cells available');
    return emptyCells[_random.nextInt(emptyCells.length)];
  }

  List<Tile?> getColumn(List<List<Tile?>> board, int col) {
    return [
      for (int row = 0; row < board.length; row++) board[row][col]
    ];
  }

  void setColumn(List<List<Tile?>> board, int col, List<Tile?> column) {
    for (int row = 0; row < board.length; row++) {
      board[row][col] = column[row];
    }
  }

  List<Tile?> getColumnReversed(List<List<Tile?>> board, int col) {
    return [
      for (int row = board.length - 1; row >= 0; row--) board[row][col]
    ];
  }

  void setColumnReversed(List<List<Tile?>> board, int col, List<Tile?> column) {
    for (int row = 0; row < board.length; row++) {
      board[board.length - 1 - row][col] = column[row];
    }
  }
}