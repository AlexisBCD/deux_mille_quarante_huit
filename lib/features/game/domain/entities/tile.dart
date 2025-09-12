import 'dart:math' as math;

enum TileType {
  normal,
  bonus,
  freeze,
}

class Tile {
  final int value;
  final int row;
  final int col;
  final TileType type;
  final int freezeRemainingTurns; // Nombre de tours restants avant dégel
  final int freezeUsesRemaining; // Nombre d'utilisations restantes pour les tuiles gel

  Tile({
    required this.value,
    required this.row,
    required this.col,
    this.type = TileType.normal,
    this.freezeRemainingTurns = 0,
    this.freezeUsesRemaining = 3, // 3 utilisations par défaut pour les tuiles gel
  });

  Tile copyWith({
    int? value,
    int? row,
    int? col,
    TileType? type,
    int? freezeRemainingTurns,
    int? freezeUsesRemaining,
  }) {
    return Tile(
      value: value ?? this.value,
      row: row ?? this.row,
      col: col ?? this.col,
      type: type ?? this.type,
      freezeRemainingTurns: freezeRemainingTurns ?? this.freezeRemainingTurns,
      freezeUsesRemaining: freezeUsesRemaining ?? this.freezeUsesRemaining,
    );
  }

  // Vérifie si cette tuile peut fusionner avec une autre
  bool canMergeWith(Tile other) {
    // Les tuiles gelées ne peuvent pas fusionner
    if (isFrozen || other.isFrozen) {
      return false;
    }
    
    // Une tuile bonus peut fusionner avec n'importe quelle tuile
    if (type == TileType.bonus || other.type == TileType.bonus) {
      return true;
    }
    
    // Les tuiles normales fusionnent seulement si elles ont la même valeur
    return value == other.value;
  }

  // Calcule la valeur résultante après fusion avec une autre tuile
  int getMergedValue(Tile other) {
    if (type == TileType.bonus && other.type == TileType.bonus) {
      // Deux tuiles bonus fusionnent en prenant la plus grande valeur * 2
      return math.max(value, other.value) * 2;
    } else if (type == TileType.bonus) {
      // Une tuile bonus prend la valeur de l'autre tuile * 2
      return other.value * 2;
    } else if (other.type == TileType.bonus) {
      // Une tuile normale avec une bonus prend sa propre valeur * 2
      return value * 2;
    } else {
      // Fusion normale : valeur * 2
      return value * 2;
    }
  }

  // Applique l'effet gel à cette tuile
  Tile applyFreeze({int turns = 3}) {
    return copyWith(
      freezeRemainingTurns: turns,
    );
  }

  // Réduit le gel d'un tour
  Tile reduceFreeze() {
    if (freezeRemainingTurns > 0) {
      return copyWith(
        freezeRemainingTurns: freezeRemainingTurns - 1,
      );
    }
    return this;
  }

  // Réduit les utilisations de la tuile gel
  Tile reduceFreezeTileUses() {
    if (isFreeze && freezeUsesRemaining > 0) {
      return copyWith(freezeUsesRemaining: freezeUsesRemaining - 1);
    }
    return this;
  }

  // Vérifie si c'est une tuile bonus
  bool get isBonus => type == TileType.bonus;

  // Vérifie si c'est une tuile normale
  bool get isNormal => type == TileType.normal;

  // Vérifie si c'est une tuile gel
  bool get isFreeze => type == TileType.freeze;

  // Vérifie si la tuile gel est épuisée
  bool get isFreezeExhausted => isFreeze && freezeUsesRemaining <= 0;

  // Vérifie si la tuile est actuellement gelée
  bool get isFrozen => freezeRemainingTurns > 0;

  // Vérifie si la tuile peut bouger
  bool get canMove => !isFrozen;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tile &&
        other.value == value &&
        other.row == row &&
        other.col == col &&
        other.type == type &&
        other.freezeRemainingTurns == freezeRemainingTurns &&
        other.freezeUsesRemaining == freezeUsesRemaining;
  }

  @override
  int get hashCode => Object.hash(value, row, col, type, freezeRemainingTurns, freezeUsesRemaining);

  @override
  String toString() {
    return 'Tile(value: $value, row: $row, col: $col, type: $type, freezeRemainingTurns: $freezeRemainingTurns, freezeUsesRemaining: $freezeUsesRemaining)';
  }
}