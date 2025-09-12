import '../entities/game_board.dart';
import '../entities/direction.dart';

abstract class GameRepository {
  GameBoard getInitialBoard();
  GameBoard addRandomTile(GameBoard board);
  GameBoard moveTiles(GameBoard board, Direction direction);
  bool canMove(GameBoard board, Direction direction);
  bool isGameOver(GameBoard board);
  void saveGame(GameBoard board);
  GameBoard? loadGame();
}