import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_hunt/services/models/auth/app_state.dart';

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void completeOnboarding() {
    state = state.copyWith(isOnboardingComplete: true);
  }
}
