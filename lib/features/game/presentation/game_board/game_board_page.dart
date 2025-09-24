import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/game_settings.dart';
import '../../domain/usecases/move_tiles_usecase.dart';
import '../../domain/usecases/reset_game_usecase.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../data/datasources/local_game_datasource.dart';
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
    final repository = GameRepositoryImpl(dataSource);
    
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