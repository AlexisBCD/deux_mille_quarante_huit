import '../domain/entities/game_mode.dart';

class HomeState {
  final GameMode? selectedMode;
  final bool isLoading;
  final String? errorMessage;

  const HomeState({
    this.selectedMode,
    this.isLoading = false,
    this.errorMessage,
  });

  HomeState copyWith({
    GameMode? selectedMode,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HomeState(
      selectedMode: selectedMode ?? this.selectedMode,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}