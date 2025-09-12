import 'package:flutter/material.dart';
import '../../domain/entities/tile.dart';

class TileTheme {
  static const Color emptyTileColor = Color(0xFFC8E6C9);

  static BoxDecoration getTileDecoration(Tile tile) {
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

    return BoxDecoration(
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
    );
  }

  static Color _getTileColor(int value) {
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

  static Color getTextColor(int value) {
    return value <= 4 
      ? const Color(0xFF2E7D32) 
      : value >= 2048
        ? Colors.white
        : const Color(0xFFF1F8E9);
  }
}