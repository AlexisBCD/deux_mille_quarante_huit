import 'package:flutter/material.dart';
import '../../domain/entities/game_mode.dart';

class GameModeCard extends StatelessWidget {
  final GameMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const GameModeCard({
    super.key,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = mode.isAvailable;
    
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF4CAF50)
              : isAvailable 
                ? Colors.white
                : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF2E7D32)
                : isAvailable 
                  ? const Color(0xFF81C784)
                  : Colors.grey.shade400,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (isSelected || isAvailable)
              BoxShadow(
                color: (isSelected ? const Color(0xFF4CAF50) : const Color(0xFF81C784))
                    .withOpacity(0.3),
                blurRadius: isSelected ? 12 : 8,
                spreadRadius: isSelected ? 2 : 1,
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.white
                    : isAvailable 
                      ? const Color(0xFF81C784)
                      : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  mode.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        mode.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected 
                              ? Colors.white
                              : isAvailable 
                                ? const Color(0xFF2E7D32)
                                : Colors.grey.shade600,
                        ),
                      ),
                      if (!isAvailable) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Bientôt',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mode.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected 
                          ? Colors.white.withOpacity(0.9)
                          : isAvailable 
                            ? const Color(0xFF4CAF50)
                            : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}