import '../../domain/entities/game_board.dart';

abstract class LocalGameDataSource {
  void saveGameState(GameBoard board);
  GameBoard? loadGameState();
  void clearGameState();
}

class LocalGameDataSourceImpl implements LocalGameDataSource {
  GameBoard? _cachedBoard;

  @override
  void saveGameState(GameBoard board) {
    _cachedBoard = board;
    // Ici vous pourriez sauvegarder dans SharedPreferences ou Hive
  }

  @override
  GameBoard? loadGameState() {
    return _cachedBoard;
  }

  @override
  void clearGameState() {
    _cachedBoard = null;
  }
}