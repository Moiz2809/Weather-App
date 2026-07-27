import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// StorageService manages persistent local storage operations using SharedPreferences.
class StorageService {
  /// Saves the last successfully searched city name to persistent storage.
  Future<void> saveLastCity(String city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLastCity, city.trim());
    } catch (_) {
      // Gracefully handle storage errors
    }
  }

  /// Retrieves the last searched city name from persistent storage.
  Future<String?> getLastCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.keyLastCity);
    } catch (_) {
      return null;
    }
  }

  /// Clears the saved last city from persistent storage.
  Future<void> clearLastCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.keyLastCity);
    } catch (_) {}
  }

  /// Saves the user's theme mode preference (true for dark, false for light).
  Future<void> saveThemeMode(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyThemeMode, isDarkMode);
    } catch (_) {}
  }

  /// Retrieves the user's saved theme mode preference.
  /// Returns false (Light Mode) by default if no preference is saved.
  Future<bool> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(AppConstants.keyThemeMode) ?? false;
    } catch (_) {
      return false;
    }
  }
}
