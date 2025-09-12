import '../repositories/game_repository.dart';

class GetBestScoreUseCase {
  final GameRepository repository;

  GetBestScoreUseCase(this.repository);

  Future<int> call() async {
    return await repository.getBestScore();
  }
}