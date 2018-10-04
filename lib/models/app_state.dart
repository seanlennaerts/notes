class AppState {
  // Your app will use this to know when to display loading spinners.
  // bool isSignedIn;
  bool isLoading;
  bool darkMode;

  // Constructor
  AppState({
    // this.isSignedIn,
    this.isLoading = false,
    this.darkMode,
  });

  factory AppState.loading() => AppState(isLoading: true);
}