import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// ThemeProvider manages the active ThemeMode (Light vs Dark) for the application.
/// Inherits from ChangeNotifier to inform the UI whenever theme changes occur.
class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService;

  // Holds the active ThemeMode (defaults to Light Mode)
  ThemeMode _themeMode = ThemeMode.light;

  /// Constructor with optional StorageService injection for unit testing.
  ThemeProvider({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Returns the current active ThemeMode enum value.
  ThemeMode get themeMode => _themeMode;

  /// Returns true if Dark Mode is currently active.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Loads saved theme preference from SharedPreferences on application startup.
  Future<void> loadThemePreference() async {
    final bool isDark = await _storageService.getThemeMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Toggles between Light and Dark mode, saves preference to SharedPreferences,
  /// and notifies listening widgets to trigger a theme rebuild.
  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    // Notify UI to rebuild instantly
    notifyListeners();

    // Persist choice to local storage
    await _storageService.saveThemeMode(isDark);
  }
}
