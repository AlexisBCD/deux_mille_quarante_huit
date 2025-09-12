import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import '../../domain/entities/direction.dart';
import '../../../../core/constants/game_constants.dart';

class GestureDetectorWidget extends StatelessWidget {
  final Widget child;

  const GestureDetectorWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) => _handleSwipe(context, details),
      child: child,
    );
  }

  void _handleSwipe(BuildContext context, DragEndDetails details) {
    const double sensitivity = GameConstants.swipeSensitivity;
    final velocity = details.velocity.pixelsPerSecond;

    // Vérifie si le geste est assez rapide
    if (velocity.distance < sensitivity) return;

    Direction? direction;

    // Détermine la direction basée sur la vélocité
    if (velocity.dx.abs() > velocity.dy.abs()) {
      // Mouvement horizontal
      if (velocity.dx > 0) {
        direction = Direction.right;
      } else {
        direction = Direction.left;
      }
    } else {
      // Mouvement vertical
      if (velocity.dy > 0) {
        direction = Direction.down;
      } else {
        direction = Direction.up;
      }
    }

    // Exécute le mouvement
    if (direction != null) {
      context.read<GameBoardCubit>().move(direction);
    }
  }
}