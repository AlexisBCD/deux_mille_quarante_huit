import '../entities/game_board.dart';
import '../entities/direction.dart';

abstract class GameRepository {
  Future<GameBoard> getInitialBoard(); // Rendu asynchrone
  GameBoard addRandomTile(GameBoard board);
  GameBoard moveTiles(GameBoard board, Direction direction);
  bool canMove(GameBoard board, Direction direction);
  bool isGameOver(GameBoard board);
  void saveGame(GameBoard board);
  GameBoard? loadGame();
  
  // Méthodes pour le meilleur score
  Future<int> getBestScore();
  Future<void> saveBestScore(int score);
}