import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/game_settings.dart';
import '../domain/entities/tile.dart';
import '../domain/entities/direction.dart';
import '../domain/entities/game_board.dart';
import '../domain/usecases/move_tiles_usecase.dart';
import '../domain/usecases/reset_game_usecase.dart';
import '../../../core/services/audio_service.dart';

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

class GameBoardCubit extends Cubit<GameBoardState> {
  final MoveTilesUseCase moveTilesUseCase;
  final ResetGameUseCase resetGameUseCase;
  final AudioService _audioService = AudioService();

  GameBoardCubit({
    required this.moveTilesUseCase,
    required this.resetGameUseCase,
    required GameSettings initialSettings,
  }) : super(GameBoardState(
          gameBoard: GameBoard(
            tiles: List.generate(
              initialSettings.boardSize,
              (index) => List.generate(initialSettings.boardSize, (index) => null),
            ),
          ),
          gameSettings: initialSettings,
        )) {
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    // Initialiser l'audio
    await _audioService.initialize();
    await _audioService.playBackgroundMusic();
    
    // Initialiser le jeu
    emit(state.copyWith(isLoading: true));
    try {
      final gameBoard = await resetGameUseCase(state.gameSettings);
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
      final newGameBoard = await moveTilesUseCase(
        state.gameBoard, 
        direction, 
        state.gameSettings,
      );
      
      // Jouer des sons en fonction des changements
      if (newGameBoard.score > state.gameBoard.score) {
        // Si le score a augmenté, il y a eu une fusion
        _audioService.playMergeSound();
      } else if (newGameBoard != state.gameBoard) {
        // Si le plateau a changé mais pas le score, c'est juste un mouvement
        _audioService.playMoveSound();
      }
      
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
      final newGameBoard = await resetGameUseCase(state.gameSettings);
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