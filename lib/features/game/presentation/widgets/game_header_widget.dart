import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import 'scores_widget.dart';
import 'action_buttons_widget.dart';

class GameHeaderWidget extends StatelessWidget {
  const GameHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            '🌸 2048 Nature 🌸',
            style: TextStyle(
              fontSize: 26, // Légèrement réduit
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 12), // Réduit de 16 à 12
          BlocBuilder<GameBoardCubit, GameBoardState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start, // Alignement en haut
                children: [
                  ScoresWidget(
                    currentScore: state.score,
                    bestScore: state.bestScore,
                  ),
                  const ActionButtonsWidget(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}