import '../repositories/game_repository.dart';

class UpdateBestScoreUseCase {
  final GameRepository repository;

  UpdateBestScoreUseCase(this.repository);

  Future<int> call(int currentScore) async {
    final bestScore = await repository.getBestScore();
    
    if (currentScore > bestScore) {
      await repository.saveBestScore(currentScore);
      return currentScore;
    }
    
    return bestScore;
  }
}