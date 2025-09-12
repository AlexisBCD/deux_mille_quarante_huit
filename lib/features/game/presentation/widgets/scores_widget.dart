import 'package:flutter/material.dart';

class ScoresWidget extends StatelessWidget {
  final int currentScore;
  final int bestScore;

  const ScoresWidget({
    super.key,
    required this.currentScore,
    required this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildScoreContainer(
          title: '🌱 SCORE',
          score: currentScore,
          isCurrentScore: true,
        ),
        const SizedBox(height: 8), // Espacement entre les deux scores
        _buildScoreContainer(
          title: '🏆 MEILLEUR',
          score: bestScore,
          isCurrentScore: false,
        ),
      ],
    );
  }

  Widget _buildScoreContainer({
    required String title,
    required int score,
    required bool isCurrentScore,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentScore 
            ? const Color(0xFF81C784) 
            : const Color(0xFFFFD54F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrentScore 
              ? const Color(0xFF4CAF50) 
              : const Color(0xFFFFA726),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isCurrentScore 
                  ? const Color(0xFF1B5E20) 
                  : const Color(0xFFE65100),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}