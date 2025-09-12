import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import '../../domain/entities/tile.dart';
import '../../domain/entities/direction.dart';

class GameBoardView extends StatelessWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8EF),
      appBar: AppBar(
        title: const Text(
          '2048',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF776E65),
          ),
        ),
        backgroundColor: const Color(0xFFFAF8EF),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<GameBoardCubit, GameBoardState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Score et bouton reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBBADA0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'SCORE',
                            style: TextStyle(
                              color: Color(0xFFEEE4DA),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${state.score}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<GameBoardCubit>().resetGame();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8F7A66),
                        foregroundColor: const Color(0xFFF9F6F2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Nouveau Jeu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Instructions mises à jour pour les tuiles bonus
                const Text(
                  'Glissez pour déplacer les tuiles. Les tuiles identiques fusionnent. Les tuiles ⭐ BONUS peuvent fusionner avec toutes les autres !',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF776E65), fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Plateau de jeu avec détection des gestes
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GestureDetector(
                        onPanEnd: (details) => _handleSwipe(context, details),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBBADA0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: GameBoardCubit.boardSize,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount:
                                GameBoardCubit.boardSize *
                                GameBoardCubit.boardSize,
                            itemBuilder: (context, index) {
                              final row = index ~/ GameBoardCubit.boardSize;
                              final col = index % GameBoardCubit.boardSize;
                              final tile = state.board[row][col];

                              return _buildTileWidget(tile);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Message de fin de jeu
                if (state.gameOver)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDC22E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Jeu terminé !',
                      style: TextStyle(
                        color: Color(0xFFF9F6F2),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Gère la détection des gestes de glissement
  void _handleSwipe(BuildContext context, DragEndDetails details) {
    const double sensitivity = 100.0;
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

  Widget _buildTileWidget(Tile? tile) {
  if (tile == null) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFCDC1B4),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  // Couleur spéciale pour les tuiles gelées
  Color tileColor;
  if (tile.isFrozen) {
    tileColor = const Color(0xFFB0E0E6); // Bleu clair pour les tuiles gelées
  } else if (tile.isBonus) {
    tileColor = const Color(0xFFFFD700); // Or pour les tuiles bonus
  } else if (tile.isFreeze) {
    tileColor = const Color(0xFF87CEEB); // Bleu ciel pour les tuiles gel
  } else {
    tileColor = _getTileColor(tile.value);
  }

  return Container(
    decoration: BoxDecoration(
      color: tileColor,
      borderRadius: BorderRadius.circular(3),
      border: tile.isBonus 
        ? Border.all(color: const Color(0xFFFF8C00), width: 2)
        : tile.isFreeze || tile.isFrozen
          ? Border.all(color: const Color(0xFF4682B4), width: 2)
          : null,
      boxShadow: tile.isBonus 
        ? [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ]
        : tile.isFreeze || tile.isFrozen
          ? [
              BoxShadow(
                color: const Color(0xFF87CEEB).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ]
          : null,
    ),
    child: Center(
      child: tile.isBonus 
        ? const Text(
            '⭐',
            style: TextStyle(
              fontSize: 40,
              color: Color(0xFFFF8C00),
            ),
          )
        : tile.isFreeze
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '❄️',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Text(
                  '${tile.freezeUsesRemaining}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${tile.value}',
                  style: TextStyle(
                    color: tile.isFrozen 
                      ? const Color(0xFF4682B4)
                      : _getTextColor(tile.value),
                    fontSize: _getFontSize(tile.value),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (tile.isFrozen)
                  Text(
                    '🧊 ${tile.freezeRemainingTurns}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4682B4),
                    ),
                  ),
              ],
            ),
    ),
  );
}

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return const Color(0xFFEEE4DA);
      case 4:
        return const Color(0xFFEDE0C8);
      case 8:
        return const Color(0xFFF2B179);
      case 16:
        return const Color(0xFFF59563);
      case 32:
        return const Color(0xFFF67C5F);
      case 64:
        return const Color(0xFFF65E3B);
      case 128:
        return const Color(0xFFEDCF72);
      case 256:
        return const Color(0xFFEDCC61);
      case 512:
        return const Color(0xFFEDC850);
      case 1024:
        return const Color(0xFFEDC53F);
      case 2048:
        return const Color(0xFFEDC22E);
      default:
        return const Color(0xFF3C3A32);
    }
  }

  Color _getTextColor(int value) {
    return value <= 4 ? const Color(0xFF776E65) : const Color(0xFFF9F6F2);
  }

  double _getFontSize(int value) {
    if (value < 100) return 32;
    if (value < 1000) return 28;
    return 24;
  }
}
