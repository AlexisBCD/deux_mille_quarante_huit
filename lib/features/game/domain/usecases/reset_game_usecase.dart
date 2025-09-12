import '../entities/game_board.dart';
import '../repositories/game_repository.dart';

class ResetGameUseCase {
  final GameRepository repository;

  ResetGameUseCase(this.repository);

  GameBoard call() {
    final initialBoard = repository.getInitialBoard();
    final boardWithTile1 = repository.addRandomTile(initialBoard);
    final boardWithTile2 = repository.addRandomTile(boardWithTile1);
    
    repository.saveGame(boardWithTile2);
    return boardWithTile2;
  }
}