import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import 'tile_widget.dart';
import 'gesture_detector_widget.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: BlocBuilder<GameBoardCubit, GameBoardState>(
            builder: (context, state) {
              return GestureDetectorWidget(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF81C784),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF4CAF50), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: state.gameSettings.boardSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.gameSettings.boardSize * state.gameSettings.boardSize,
                    itemBuilder: (context, index) {
                      final row = index ~/ state.gameSettings.boardSize;
                      final col = index % state.gameSettings.boardSize;
                      final tile = state.board[row][col];
                      return TileWidget(tile: tile);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}