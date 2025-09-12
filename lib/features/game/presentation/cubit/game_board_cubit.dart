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
  }) : super(GameBoardState(gameBoard: resetGameUseCase()));

  void move(Direction direction) {
    if (state.gameOver || state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    try {
      final newGameBoard = moveTilesUseCase(state.gameBoard, direction);
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

  void resetGame() {
    emit(state.copyWith(isLoading: true));

    try {
      final newGameBoard = resetGameUseCase();
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