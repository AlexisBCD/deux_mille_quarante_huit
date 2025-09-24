import '../../domain/repositories/game_repository.dart';
import '../../domain/entities/game_board.dart';
import '../../domain/entities/game_settings.dart';
import '../../domain/entities/direction.dart';
import '../datasources/local_game_datasource.dart';
import '../services/tile_generation_service.dart';
import '../services/freeze_effect_service.dart';
import '../services/movement_service.dart';
import '../services/board_utils_service.dart';

class GameRepositoryImpl implements GameRepository {
  final LocalGameDataSource dataSource;
  final TileGenerationService _tileGenerationService;
  final FreezeEffectService _freezeEffectService;
  final MovementService _movementService;
  final BoardUtilsService _boardUtilsService;

  GameRepositoryImpl({
    required this.dataSource,
    required TileGenerationService tileGenerationService,
    required FreezeEffectService freezeEffectService,
    required MovementService movementService,
    required BoardUtilsService boardUtilsService,
  })  : _tileGenerationService = tileGenerationService,
        _freezeEffectService = freezeEffectService,
        _movementService = movementService,
        _boardUtilsService = boardUtilsService;

  @override
  Future<int> getBestScore() async {
    return await dataSource.getBestScore();
  }

  @override
  Future<void> saveBestScore(int score) async {
    await dataSource.saveBestScore(score);
  }

  @override
  Future<GameBoard> getInitialBoard(GameSettings settings) async {
    final bestScore = await getBestScore();
    return GameBoard(
      tiles: List.generate(
        settings.boardSize,
        (index) => List.generate(settings.boardSize, (index) => null),
      ),
      bestScore: bestScore,
    );
  }

  @override
  GameBoard addRandomTile(GameBoard board, GameSettings settings) {
    final emptyCells = board.getEmptyCells();
    if (emptyCells.isEmpty) return board;

    final randomCell = _boardUtilsService.getRandomEmptyCell(emptyCells);
    final row = randomCell[0];
    final col = randomCell[1];

    final newTile = _tileGenerationService.generateRandomTile(row, col, settings);
    
    final newTiles = _boardUtilsService.copyBoard(board.tiles, settings.boardSize);
    newTiles[row][col] = newTile;

    return board.copyWith(tiles: newTiles);
  }

  @override
  GameBoard moveTiles(GameBoard board, Direction direction, GameSettings settings) {
    // D'abord appliquer les effets de gel (les tuiles de gel affectent leurs voisins)
    final boardWithFreezeEffects = _freezeEffectService.applyFreezeEffects(board, settings);
    
    // Puis effectuer le mouvement
    final result = _movementService.moveAndMergeTiles(boardWithFreezeEffects, direction, settings);
    
    return result;
  }

  @override
  bool canMove(GameBoard board, Direction direction, GameSettings settings) {
    final testBoard = _movementService.moveAndMergeTiles(board, direction, settings);
    return testBoard != board; // Si le board a changé, alors on peut bouger
  }

  @override
  bool isGameOver(GameBoard board, GameSettings settings) {
    if (!board.isFull) return false;
    
    // Vérifie si des mouvements sont possibles
    for (final direction in Direction.values) {
      if (canMove(board, direction, settings)) return false;
    }
    
    return true;
  }

  @override
  void saveGame(GameBoard board) {
    dataSource.saveGameState(board);
  }

  @override
  GameBoard? loadGame() {
    return dataSource.loadGameState();
  }
}