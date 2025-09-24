import 'package:deux_mille_quarante_huit/features/game/domain/entities/tile.dart';

import '../../domain/entities/game_board.dart';
import '../../domain/entities/game_settings.dart';

class GameBoardState {
  final GameBoard gameBoard;
  final GameSettings gameSettings;
  final bool isLoading;
  final String? errorMessage;

  const GameBoardState({
    required this.gameBoard,
    required this.gameSettings,
    this.isLoading = false,
    this.errorMessage,
  });

  GameBoardState copyWith({
    GameBoard? gameBoard,
    GameSettings? gameSettings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GameBoardState(
      gameBoard: gameBoard ?? this.gameBoard,
      gameSettings: gameSettings ?? this.gameSettings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  // Getters de commodité
  List<List<Tile?>> get board => gameBoard.tiles;
  int get score => gameBoard.score;
  int get bestScore => gameBoard.bestScore;
  bool get gameOver => gameBoard.isGameOver;
}