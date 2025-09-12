import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import '../widgets/flower_background_widget.dart';
import '../widgets/game_header_widget.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/game_over_widget.dart';

class GameBoardView extends StatelessWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8),
      body: Stack(
        children: [
          const FlowerBackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                const GameHeaderWidget(),
                Expanded(
                  child: BlocBuilder<GameBoardCubit, GameBoardState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const GameBoardWidget(),
                            if (state.gameOver) const GameOverWidget(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}