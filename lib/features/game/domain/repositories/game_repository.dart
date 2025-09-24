import '../entities/game_board.dart';
import '../entities/direction.dart';
import '../entities/game_settings.dart';

abstract class GameRepository {
  Future<GameBoard> getInitialBoard(GameSettings settings);
  GameBoard addRandomTile(GameBoard board, GameSettings settings);
  GameBoard moveTiles(GameBoard board, Direction direction, GameSettings settings);
  bool canMove(GameBoard board, Direction direction, GameSettings settings);
  bool isGameOver(GameBoard board, GameSettings settings);
  void saveGame(GameBoard board);
  GameBoard? loadGame();
  
  // Méthodes pour le meilleur score
  Future<int> getBestScore();
  Future<void> saveBestScore(int score);
}