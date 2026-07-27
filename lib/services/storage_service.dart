import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// StorageService manages persistent local storage operations using SharedPreferences.
class StorageService {
  /// Saves the last successfully searched city name to persistent storage.
  Future<void> saveLastCity(String city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLastCity, city.trim());
    } catch (_) {}
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

  /// Saves the user's theme mode preference.
  Future<void> saveThemeMode(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyThemeMode, isDarkMode);
    } catch (_) {}
  }

  /// Retrieves the user's saved theme mode preference.
  Future<bool> getThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(AppConstants.keyThemeMode) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Saves the list of favorite cities to persistent storage.
  Future<void> saveFavoriteCities(List<String> cities) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(AppConstants.keyRecentCities, cities);
    } catch (_) {}
  }

  /// Retrieves the list of favorite cities from persistent storage.
  Future<List<String>> getFavoriteCities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(AppConstants.keyRecentCities) ?? [];
    } catch (_) {
      return [];
    }
  }

  /// Saves search history list (last 10 cities) to persistent storage.
  Future<void> saveSearchHistory(List<String> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', history);
    } catch (_) {}
  }

  /// Retrieves search history list from persistent storage.
  Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('search_history') ?? [];
    } catch (_) {
      return [];
    }
  }
}
