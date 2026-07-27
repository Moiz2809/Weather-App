import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// StorageService manages persistent local storage operations using SharedPreferences.
class StorageService {
  /// Saves the last successfully searched city name to persistent storage.
  Future<void> saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyLastCity, city.trim());
  }

  /// Retrieves the last searched city name from persistent storage.
  /// Returns null if no city has been saved yet.
  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.keyLastCity);
  }

  /// Clears the saved last city from persistent storage.
  Future<void> clearLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyLastCity);
  }
}
