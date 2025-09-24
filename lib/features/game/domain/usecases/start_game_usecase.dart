import '../entities/game_board.dart';
import '../entities/game_settings.dart';
import '../repositories/game_repository.dart';

class StartGameUseCase {
  final GameRepository repository;

  StartGameUseCase(this.repository);

  Future<GameBoard> call(GameSettings settings) async {
    final initialBoard = await repository.getInitialBoard(settings);
    final boardWithTile1 = repository.addRandomTile(initialBoard, settings);
    final boardWithTile2 = repository.addRandomTile(boardWithTile1, settings);
    
    repository.saveGame(boardWithTile2);
    return boardWithTile2;
  }
}