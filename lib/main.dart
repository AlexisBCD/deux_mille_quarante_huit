import 'package:flutter/material.dart';
import 'features/game/presentation/game_board/game_board_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Roboto',
      ),
      home: const GameBoardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}