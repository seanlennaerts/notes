import 'package:notes/database/database.dart';

class AppState {
  // Your app will use this to know when to display loading spinners.
  // bool isSignedIn;
  bool isLoading;
  bool darkMode;
  DatabaseHelper db;

  // Constructor
  AppState({
    // this.isSignedIn,
    this.isLoading = false,
    this.darkMode,
    this.db,
  });

  factory AppState.loading() => AppState(isLoading: true);
}