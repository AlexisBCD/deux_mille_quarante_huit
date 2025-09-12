class TileEmojiMapper {
  static String getEmoji(int value) {
    switch (value) {
      case 2: return '🌱';
      case 4: return '🌿';
      case 8: return '☘️';
      case 16: return '🌾';
      case 32: return '🌸';
      case 64: return '🌺';
      case 128: return '🌻';
      case 256: return '🌹';
      case 512: return '🌳';
      case 1024: return '🌲';
      case 2048: return '🌴';
      case 4096: return '🎋';
      case 8192: return '🌊';
      default: return '🍃';
    }
  }

  static double getFontSize(int value) {
    if (value < 100) return 28;
    if (value < 1000) return 24;
    if (value < 10000) return 20;
    return 18;
  }
}