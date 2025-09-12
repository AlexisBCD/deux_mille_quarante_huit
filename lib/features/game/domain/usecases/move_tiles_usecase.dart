import '../entities/game_board.dart';
import '../entities/direction.dart';
import '../repositories/game_repository.dart';

class MoveTilesUseCase {
  final GameRepository repository;

  MoveTilesUseCase(this.repository);

  Future<GameBoard> call(GameBoard board, Direction direction) async {
    if (!repository.canMove(board, direction)) {
      return board;
    }

    final movedBoard = repository.moveTiles(board, direction);
    final boardWithNewTile = repository.addRandomTile(movedBoard);
    
    // Met à jour le meilleur score si nécessaire
    final currentBestScore = await repository.getBestScore();
    final newBestScore = boardWithNewTile.score > currentBestScore 
        ? boardWithNewTile.score 
        : currentBestScore;
    
    if (boardWithNewTile.score > currentBestScore) {
      await repository.saveBestScore(boardWithNewTile.score);
    }
    
    final finalBoard = boardWithNewTile.copyWith(
      isGameOver: repository.isGameOver(boardWithNewTile),
      bestScore: newBestScore,
    );

    repository.saveGame(finalBoard);
    return finalBoard;
  }
}