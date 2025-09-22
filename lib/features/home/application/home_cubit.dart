import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/game_mode.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectGameMode(GameMode mode) {
    if (!mode.isAvailable) return;
    
    emit(state.copyWith(selectedMode: mode));
  }

  void startGame() {
    if (state.selectedMode == null) return;
    
    emit(state.copyWith(isLoading: true));
    // La navigation sera gérée dans la vue
  }

  void clearSelection() {
    emit(state.copyWith(
      selectedMode: null, 
      isLoading: false,
      errorMessage: null,
    ));
  }

  // Méthode pour reset complètement l'état
  void resetToInitial() {
    emit(const HomeState());
  }
}