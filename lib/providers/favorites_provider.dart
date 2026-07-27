import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// FavoritesProvider manages the user's saved favorite cities list.
/// Inherits from ChangeNotifier to notify UI components on addition or removal.
class FavoritesProvider extends ChangeNotifier {
  final StorageService _storageService;

  // List of saved favorite city names
  List<String> _favoriteCities = [];

  /// Constructor with dependency injection.
  FavoritesProvider({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Returns unmodifiable list of saved favorite city names.
  List<String> get favoriteCities => List.unmodifiable(_favoriteCities);

  /// Loads saved favorite cities from SharedPreferences on app launch.
  Future<void> loadFavorites() async {
    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
  }

  /// Checks if a city is already in the favorites list (case-insensitive).
  bool isFavorite(String city) {
    return _favoriteCities.any(
      (item) => item.trim().toLowerCase() == city.trim().toLowerCase(),
    );
  }

  /// Toggles favorite status: adds if not present, removes if already present.
  Future<void> toggleFavorite(String city) async {
    final trimmedCity = city.trim();
    if (trimmedCity.isEmpty) return;

    if (isFavorite(trimmedCity)) {
      _favoriteCities.removeWhere(
        (item) => item.trim().toLowerCase() == trimmedCity.toLowerCase(),
      );
    } else {
      _favoriteCities.add(trimmedCity);
    }

    notifyListeners();
    await _storageService.saveFavoriteCities(_favoriteCities);
  }

  /// Removes a specific city from favorites.
  Future<void> removeFavorite(String city) async {
    _favoriteCities.removeWhere(
      (item) => item.trim().toLowerCase() == city.trim().toLowerCase(),
    );
    notifyListeners();
    await _storageService.saveFavoriteCities(_favoriteCities);
  }
}
