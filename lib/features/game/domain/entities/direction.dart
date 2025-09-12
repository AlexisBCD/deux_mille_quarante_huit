enum Direction {
  up,
  down,
  left,
  right,
}

extension DirectionExtension on Direction {
  // Retourne les deltas de mouvement (row, col) pour chaque direction
  List<int> get delta {
    switch (this) {
      case Direction.up:
        return [-1, 0];
      case Direction.down:
        return [1, 0];
      case Direction.left:
        return [0, -1];
      case Direction.right:
        return [0, 1];
    }
  }

  // Retourne le nom de la direction en français
  String get name {
    switch (this) {
      case Direction.up:
        return 'Haut';
      case Direction.down:
        return 'Bas';
      case Direction.left:
        return 'Gauche';
      case Direction.right:
        return 'Droite';
    }
  }

  // Retourne la direction opposée
  Direction get opposite {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }
}