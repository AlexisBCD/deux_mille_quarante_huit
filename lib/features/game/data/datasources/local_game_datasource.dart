import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/game_board.dart';

abstract class LocalGameDataSource {
  void saveGameState(GameBoard board);
  GameBoard? loadGameState();
  void clearGameState();
  Future<int> getBestScore();
  Future<void> saveBestScore(int score);
}

class LocalGameDataSourceImpl implements LocalGameDataSource {
  static const String _bestScoreKey = 'best_score';
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

  @override
  Future<int> getBestScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_bestScoreKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<void> saveBestScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_bestScoreKey, score);
    } catch (e) {
      // Log l'erreur si nécessaire
    }
  }
}