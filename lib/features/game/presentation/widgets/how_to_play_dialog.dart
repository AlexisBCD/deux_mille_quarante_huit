import 'package:flutter/material.dart';

void showHowToPlayDialog(BuildContext context) {
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
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Glissez pour déplacer les tuiles. Faites grandir votre jardin en fusionnant les mêmes plantes !',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Progression des plantes :',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '🌱 → 🌿 → ☘️ → 🌾 → 🌸 → 🌺 → 🌻 → 🌹 → 🌳 → 🌲 → 🌴',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              _RuleItem(
                emoji: '🌟',
                title: 'ÉTOILE',
                description: 'peut fusionner avec toutes les autres tuiles !',
              ),
              SizedBox(height: 8),
              _RuleItem(
                emoji: '❄️',
                title: 'GELÉE',
                description: 'gèle les tuiles adjacentes pendant plusieurs tours.',
              ),
              SizedBox(height: 8),
              _RuleItem(
                emoji: '🧊',
                title: 'GELÉES',
                description: 'tuiles temporairement bloquées par le froid.',
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFE8F5E8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF4CAF50),
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

class _RuleItem extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _RuleItem({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: '$title : ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: description),
              ],
            ),
          ),
        ),
      ],
    );
  }
}