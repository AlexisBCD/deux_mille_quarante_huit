import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import '../../application/game_board_cubit.dart';
import '../../domain/entities/tile.dart';
import '../../domain/entities/direction.dart';

class GameBoardView extends StatelessWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E8), // Vert très clair naturel
      body: Stack(
        children: [
          // Arrière-plan avec fleurs
          _buildFlowerBackground(),
          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                // AppBar personnalisée
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '🌸 2048 Nature 🌸',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E7D32), // Vert foncé
                    ),
                  ),
                ),
                
                // Corps principal
                Expanded(
                  child: BlocBuilder<GameBoardCubit, GameBoardState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Score et boutons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF81C784), // Vert moyen
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF4CAF50),
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '🌱 SCORE',
                                        style: TextStyle(
                                          color: Color(0xFF1B5E20),
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
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => _showHowToPlay(context),
                                      icon: const Icon(Icons.info_outline),
                                      style: IconButton.styleFrom(
                                        backgroundColor: const Color(0xFF4CAF50), // Vert
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.all(12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<GameBoardCubit>().resetGame();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF4CAF50),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        '🌿 Nouveau Jardin',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Plateau de jeu
                            Expanded(
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: GestureDetector(
                                    onPanEnd: (details) => _handleSwipe(context, details),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF81C784),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF4CAF50),
                                          width: 3,
                                        ),
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
                                  color: const Color(0xFFFF7043), // Orange naturel
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE64A19),
                                    width: 2,
                                  ),
                                ),
                                child: const Text(
                                  '🍂 Automne arrivé ! 🍂',
                                  style: TextStyle(
                                    color: Colors.white,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowerBackground() {
    final random = Random();
    final flowers = ['🌸', '🌺', '🌻', '🌷', '🌹', '🏵️', '💐', '🌼'];
    
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: List.generate(20, (index) {
            return Positioned(
              left: random.nextDouble() * 400,
              top: random.nextDouble() * 800,
              child: Opacity(
                opacity: 0.15,
                child: Text(
                  flowers[random.nextInt(flowers.length)],
                  style: TextStyle(
                    fontSize: 20 + random.nextDouble() * 20,
                  ),
                ),
              ),
            );
          }),
        ),
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
          color: const Color(0xFFC8E6C9), // Vert très clair
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFA5D6A7),
            width: 1,
          ),
        ),
      );
    }

    // Couleur spéciale pour les tuiles gelées
    Color tileColor;
    if (tile.isFrozen) {
      tileColor = const Color(0xFF81D4FA); // Bleu clair glacé
    } else if (tile.isBonus) {
      tileColor = const Color(0xFFFFD54F); // Jaune soleil
    } else if (tile.isFreeze) {
      tileColor = const Color(0xFFB39DDB); // Violet gel
    } else {
      tileColor = _getTileColor(tile.value);
    }

    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(8),
        border: tile.isBonus 
          ? Border.all(color: const Color(0xFFFFA726), width: 2)
          : tile.isFreeze || tile.isFrozen
            ? Border.all(color: const Color(0xFF7986CB), width: 2)
            : Border.all(color: const Color(0xFF66BB6A), width: 1),
        boxShadow: tile.isBonus 
          ? [
              BoxShadow(
                color: const Color(0xFFFFD54F).withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 1,
              )
            ]
          : tile.isFreeze || tile.isFrozen
            ? [
                BoxShadow(
                  color: const Color(0xFFB39DDB).withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ],
      ),
      child: Center(
        child: tile.isBonus 
          ? const Text(
              '🌟',
              style: TextStyle(
                fontSize: 40,
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
                      color: Color(0xFF5C6BC0),
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
                        ? const Color(0xFF1976D2)
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
                        color: Color(0xFF1976D2),
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
        return const Color(0xFFE8F5E8); // Vert très clair
      case 4:
        return const Color(0xFFC8E6C9); // Vert clair
      case 8:
        return const Color(0xFFA5D6A7); // Vert moyen clair
      case 16:
        return const Color(0xFF81C784); // Vert moyen
      case 32:
        return const Color(0xFF66BB6A); // Vert
      case 64:
        return const Color(0xFF4CAF50); // Vert foncé
      case 128:
        return const Color(0xFF43A047); // Vert plus foncé
      case 256:
        return const Color(0xFF388E3C); // Vert très foncé
      case 512:
        return const Color(0xFF2E7D32); // Vert forêt
      case 1024:
        return const Color(0xFF1B5E20); // Vert très sombre
      case 2048:
        return const Color(0xFF0D47A1); // Bleu profond (achievement)
      default:
        return const Color(0xFF263238); // Gris foncé
    }
  }

  Color _getTextColor(int value) {
    return value <= 4 
      ? const Color(0xFF2E7D32) 
      : value >= 2048
        ? Colors.white
        : const Color(0xFFF1F8E9);
  }

  double _getFontSize(int value) {
    if (value < 100) return 32;
    if (value < 1000) return 28;
    return 24;
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '🌿 Comment cultiver votre jardin',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Glissez pour déplacer les tuiles. Les tuiles identiques fusionnent comme des plantes qui grandissent !\n\n'
            '🌟 ÉTOILE : peut fusionner avec toutes les autres tuiles !\n\n'
            '❄️ GELÉE : gèle les tuiles adjacentes pendant plusieurs tours.\n\n'
            '🧊 GELÉES : tuiles temporairement bloquées par le froid.',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xFFE8F5E8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF4CAF50),
              width: 2,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text(
                '🌱 Compris !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}