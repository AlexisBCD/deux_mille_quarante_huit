import 'package:deux_mille_quarante_huit/features/game/domain/entities/game_board.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/direction.dart';
import '../../domain/usecases/move_tiles_usecase.dart';
import '../../domain/usecases/reset_game_usecase.dart';
import 'game_board_state.dart';

class GameBoardCubit extends Cubit<GameBoardState> {
  final MoveTilesUseCase moveTilesUseCase;
  final ResetGameUseCase resetGameUseCase;

  GameBoardCubit({
    required this.moveTilesUseCase,
    required this.resetGameUseCase,
  }) : super(GameBoardState(gameBoard: GameBoard(tiles: []))) {
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    emit(state.copyWith(isLoading: true));
    try {
      final gameBoard = await resetGameUseCase();
      emit(state.copyWith(
        gameBoard: gameBoard,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> move(Direction direction) async {
    if (state.gameOver || state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    try {
      final newGameBoard = await moveTilesUseCase(state.gameBoard, direction);
      emit(state.copyWith(
        gameBoard: newGameBoard,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> resetGame() async {
    emit(state.copyWith(isLoading: true));

    try {
      final newGameBoard = await resetGameUseCase();
      emit(state.copyWith(
        gameBoard: newGameBoard,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}