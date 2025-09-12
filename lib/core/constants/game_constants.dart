import 'package:flutter/material.dart';

class GameConstants {
  static const int boardSize = 4;
  static const double swipeSensitivity = 100.0;
  static const int defaultFreezeUsesRemaining = 3;
  static const int defaultFreezeTurns = 3;
  
  // Probabilités d'apparition des tuiles
  static const double bonusTileProbability = 0.05;
  static const double freezeTileProbability = 0.03;
  static const double value2Probability = 0.85;
  static const double value4Probability = 0.07;

  // Couleurs du thème nature
  static const backgroundColor = Color(0xFFE8F5E8);
  static const primaryGreen = Color(0xFF4CAF50);
  static const darkGreen = Color(0xFF2E7D32);
  static const lightGreen = Color(0xFF81C784);
}