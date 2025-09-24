import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import '../widgets/flower_background_widget.dart';
import '../widgets/game_header_widget.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/game_over_widget.dart';
import '../widgets/audio_control_widget.dart';

class GameBoardView extends StatelessWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Confirme si l'utilisateur veut vraiment quitter
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              '🌿 Quitter le jardin ?',
              style: TextStyle(color: Color(0xFF2E7D32)),
            ),
            content: const Text(
              'Votre progression sera sauvegardée.',
              style: TextStyle(color: Color(0xFF2E7D32)),
            ),
            backgroundColor: const Color(0xFFE8F5E8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Continuer',
                  style: TextStyle(color: Color(0xFF4CAF50)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Quitter',
                  style: TextStyle(color: Color(0xFFFF7043)),
                ),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
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
      ),
    );
  }
}