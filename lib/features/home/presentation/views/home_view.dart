import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/home_cubit.dart';
import '../../application/home_state.dart';
import '../../domain/entities/game_mode.dart';
import '../widgets/game_mode_card.dart';
import '../widgets/start_game_button.dart';
import '../widgets/home_header.dart';
import '../../../game/presentation/game_board/game_board_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E8), // Vert très clair
              Color(0xFFC8E6C9), // Vert clair
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state.isLoading && state.selectedMode != null) {
                // Navigation vers le jeu
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GameBoardPage(),
                  ),
                ).then((_) {
                  // Reset l'état quand on revient - plus complet
                  context.read<HomeCubit>().resetToInitial();
                });
              }
            },
            child: Column(
              children: [
                const HomeHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Choisissez votre mode de jeu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              return ListView.separated(
                                itemCount: GameMode.values.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final mode = GameMode.values[index];
                                  return GameModeCard(
                                    mode: mode,
                                    isSelected: state.selectedMode == mode,
                                    onTap: () => context.read<HomeCubit>().selectGameMode(mode),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return StartGameButton(
                              isEnabled: state.selectedMode != null,
                              isLoading: state.isLoading,
                              onPressed: () => context.read<HomeCubit>().startGame(),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}