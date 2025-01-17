class AppState {
  final bool isOnboardingComplete;

  AppState({this.isOnboardingComplete = false});

  AppState copyWith({bool? isOnboardingComplete}) {
    return AppState(
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }
}
