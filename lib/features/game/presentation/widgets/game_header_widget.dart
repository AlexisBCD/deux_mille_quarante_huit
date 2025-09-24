import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import 'scores_widget.dart';
import 'action_buttons_widget.dart';
import 'audio_control_widget.dart';

class GameHeaderWidget extends StatelessWidget {
  const GameHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              // Bouton retour
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Titre centré
              Expanded(
                child: Text(
                  '🌸 2048 Nature 🌸',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24, // Réduit pour faire de la place
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              // Bouton de contrôle audio
              const AudioControlWidget(),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<GameBoardCubit, GameBoardState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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