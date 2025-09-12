import '../entities/game_board.dart';
import '../entities/direction.dart';
import '../repositories/game_repository.dart';

class MoveTilesUseCase {
  final GameRepository repository;

  MoveTilesUseCase(this.repository);

  GameBoard call(GameBoard board, Direction direction) {
    if (!repository.canMove(board, direction)) {
      return board;
    }

    final movedBoard = repository.moveTiles(board, direction);
    final boardWithNewTile = repository.addRandomTile(movedBoard);
    
    final finalBoard = boardWithNewTile.copyWith(
      isGameOver: repository.isGameOver(boardWithNewTile),
    );

    repository.saveGame(finalBoard);
    return finalBoard;
  }
}