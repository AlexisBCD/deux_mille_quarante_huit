import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game_settings.dart';
import '../../domain/usecases/move_tiles_usecase.dart';
import '../../domain/usecases/reset_game_usecase.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../data/datasources/local_game_datasource.dart';
import '../../data/services/tile_generation_service.dart';
import '../../data/services/freeze_effect_service.dart';
import '../../data/services/movement_service.dart';
import '../../data/services/board_utils_service.dart';
import '../../application/game_board_cubit.dart';
import './game_board_view.dart';

class GameBoardPage extends StatelessWidget {
  final GameSettings gameSettings;

  const GameBoardPage({
    super.key,
    required this.gameSettings,
  });

  @override
  Widget build(BuildContext context) {
    final dataSource = LocalGameDataSourceImpl();
    
    // Créer les services
    final boardUtilsService = BoardUtilsService();
    final tileGenerationService = TileGenerationService();
    final freezeEffectService = FreezeEffectService();
    final movementService = MovementService(boardUtilsService);
    
    final repository = GameRepositoryImpl(
      dataSource: dataSource,
      tileGenerationService: tileGenerationService,
      freezeEffectService: freezeEffectService,
      movementService: movementService,
      boardUtilsService: boardUtilsService,
    );
    
    return BlocProvider(
      create: (context) => GameBoardCubit(
        moveTilesUseCase: MoveTilesUseCase(repository),
        resetGameUseCase: ResetGameUseCase(repository),
        initialSettings: gameSettings,
      ),
      child: const GameBoardView(),
    );
  }
}