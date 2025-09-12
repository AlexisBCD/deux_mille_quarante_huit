import 'package:flutter/material.dart';
import 'dart:math';

class FlowerBackgroundWidget extends StatefulWidget {
  const FlowerBackgroundWidget({super.key});

  @override
  State<FlowerBackgroundWidget> createState() => _FlowerBackgroundWidgetState();
}

class _FlowerBackgroundWidgetState extends State<FlowerBackgroundWidget> {
  late final List<FlowerData> _flowers;

  @override
  void initState() {
    super.initState();
    // Génère les positions UNE SEULE FOIS à l'initialisation
    _flowers = _generateFlowers();
  }

  List<FlowerData> _generateFlowers() {
    final random = Random(42); // Seed fixe
    final flowerEmojis = ['🌸', '🌺', '🌻', '🌷', '🌹', '🏵️', '💐', '🌼', '🌿', '🍃'];
    
    return List.generate(20, (index) {
      return FlowerData(
        flowerEmojis[random.nextInt(flowerEmojis.length)],
        random.nextDouble(),
        random.nextDouble(),
        15 + random.nextDouble() * 25,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: FlowerBackgroundPainter(_flowers),
        ),
      ),
    );
  }
}

class FlowerData {
  final String emoji;
  final double relativeX;
  final double relativeY;
  final double fontSize;

  const FlowerData(this.emoji, this.relativeX, this.relativeY, this.fontSize);
}

class FlowerBackgroundPainter extends CustomPainter {
  final List<FlowerData> flowers;

  FlowerBackgroundPainter(this.flowers);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final flower in flowers) {
      textPainter.text = TextSpan(
        text: flower.emoji,
        style: TextStyle(
          fontSize: flower.fontSize,
          color: Colors.black.withOpacity(0.1),
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas, 
        Offset(
          flower.relativeX * size.width, 
          flower.relativeY * size.height,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}