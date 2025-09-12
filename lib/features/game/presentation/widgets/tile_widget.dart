import 'package:flutter/material.dart';
import '../../domain/entities/tile.dart';
import '../utils/tile_theme.dart';
import '../utils/tile_emoji_mapper.dart';

class TileWidget extends StatelessWidget {
  final Tile? tile;

  const TileWidget({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    if (tile == null) {
      return Container(
        decoration: BoxDecoration(
          color: TileTheme.emptyTileColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFA5D6A7), width: 1),
        ),
      );
    }

    return Container(
      decoration: TileTheme.getTileDecoration(tile!),
      child: Center(
        child: _buildTileContent(),
      ),
    );
  }

  Widget _buildTileContent() {
    if (tile!.isBonus) {
      return const Text('🌟', style: TextStyle(fontSize: 40));
    }
    
    if (tile!.isFreeze) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('❄️', style: TextStyle(fontSize: 30)),
          Text(
            '${tile!.freezeUsesRemaining}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF5C6BC0)),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          TileEmojiMapper.getEmoji(tile!.value),
          style: TextStyle(fontSize: TileEmojiMapper.getFontSize(tile!.value)),
        ),
        const SizedBox(height: 2),
        Text(
          '${tile!.value}',
          style: TextStyle(
            color: tile!.isFrozen ? const Color(0xFF1976D2) : TileTheme.getTextColor(tile!.value),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (tile!.isFrozen)
          Text(
            '🧊 ${tile!.freezeRemainingTurns}',
            style: const TextStyle(fontSize: 10, color: Color(0xFF1976D2)),
          ),
      ],
    );
  }
}