import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/game_board_cubit.dart';
import 'game_board_view.dart';

class GameBoardPage extends StatelessWidget {
  const GameBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBoardCubit(),
      child: const GameBoardView(),
    );
  }
}