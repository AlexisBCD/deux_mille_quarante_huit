import '../entities/game_board.dart';
import '../entities/direction.dart';
import '../entities/game_settings.dart';
import '../repositories/game_repository.dart';

class MoveTilesUseCase {
  final GameRepository repository;

  MoveTilesUseCase(this.repository);

  Future<GameBoard> call(GameBoard board, Direction direction, GameSettings settings) async {
    if (!repository.canMove(board, direction, settings)) {
      return board;
    }

    final movedBoard = repository.moveTiles(board, direction, settings);
    final boardWithNewTile = repository.addRandomTile(movedBoard, settings);
    
    // Met à jour le meilleur score si nécessaire
    final currentBestScore = await repository.getBestScore();
    final newBestScore = boardWithNewTile.score > currentBestScore 
        ? boardWithNewTile.score 
        : currentBestScore;
    
    if (boardWithNewTile.score > currentBestScore) {
      await repository.saveBestScore(boardWithNewTile.score);
    }
    
    final finalBoard = boardWithNewTile.copyWith(
      isGameOver: repository.isGameOver(boardWithNewTile, settings),
      bestScore: newBestScore,
    );

    repository.saveGame(finalBoard);
    return finalBoard;
  }
}