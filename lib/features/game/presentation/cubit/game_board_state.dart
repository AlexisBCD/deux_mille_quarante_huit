import 'package:deux_mille_quarante_huit/features/game/domain/entities/tile.dart';

import '../../domain/entities/game_board.dart';

class GameBoardState {
  final GameBoard gameBoard;
  final bool isLoading;
  final String? errorMessage;

  const GameBoardState({
    required this.gameBoard,
    this.isLoading = false,
    this.errorMessage,
  });

  GameBoardState copyWith({
    GameBoard? gameBoard,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GameBoardState(
      gameBoard: gameBoard ?? this.gameBoard,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  // Getters de commodité
  List<List<Tile?>> get board => gameBoard.tiles;
  int get score => gameBoard.score;
  bool get gameOver => gameBoard.isGameOver;
}