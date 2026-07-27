import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// HistoryProvider manages recent search history for up to 10 cities.
/// Prevents duplicate entries and persists state using SharedPreferences.
class HistoryProvider extends ChangeNotifier {
  final StorageService _storageService;

  // List holding up to 10 recent city search strings
  List<String> _history = [];

  /// Constructor with dependency injection.
  HistoryProvider({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Returns unmodifiable list of recent search history items.
  List<String> get history => List.unmodifiable(_history);

  /// Returns true if history is empty.
  bool get isEmpty => _history.isEmpty;

  /// Loads search history from SharedPreferences on app startup.
  Future<void> loadHistory() async {
    _history = await _storageService.getSearchHistory();
    notifyListeners();
  }

  /// Adds a new city search query to the history.
  /// Prevents duplicates by removing prior entries and caps the list at 10 items.
  Future<void> addSearch(String city) async {
    final trimmedCity = city.trim();
    if (trimmedCity.isEmpty) return;

    // 1. Remove duplicate entries (case-insensitive check)
    _history.removeWhere(
      (item) => item.toLowerCase() == trimmedCity.toLowerCase(),
    );

    // 2. Insert new search at the top of the list
    _history.insert(0, trimmedCity);

    // 3. Keep only the last 10 searches
    if (_history.length > 10) {
      _history = _history.sublist(0, 10);
    }

    notifyListeners();

    // 4. Save to SharedPreferences
    await _storageService.saveSearchHistory(_history);
  }

  /// Clears all recent search history items.
  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();
    await _storageService.saveSearchHistory(_history);
  }
}
