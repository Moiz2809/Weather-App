import 'package:flutter/foundation.dart';
import '../core/app_exception.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';
import '../utils/validator.dart';

/// WeatherProvider manages application state for weather data, loading status,
/// error messages, input validation, and persistent city search history.
class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final StorageService _storageService;

  // --- Private State Variables ---
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCity = AppConstants.defaultCity;

  /// Constructor with dependency injection.
  WeatherProvider({
    WeatherService? weatherService,
    StorageService? storageService,
  })  : _weatherService = weatherService ?? WeatherService(),
        _storageService = storageService ?? StorageService();

  // --- Public Getters ---
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _weather != null && !_isLoading;
  String get currentCity => _currentCity;

  // --- Persistence Action ---
  Future<void> loadSavedCityOrFallback() async {
    final String? savedCity = await _storageService.getLastCity();

    if (savedCity != null && savedCity.isNotEmpty) {
      _currentCity = savedCity;
    } else {
      _currentCity = AppConstants.defaultCity;
    }

    await fetchWeather(_currentCity);
  }

  // --- Weather Fetch Action with Validation ---
  Future<void> fetchWeather(String city) async {
    // 1. Run Input Validation
    final String? validationError = CityValidator.validate(city);
    if (validationError != null) {
      _errorMessage = validationError;
      _isLoading = false;
      notifyListeners();
      return;
    }

    // 2. Clear previous error and set loading state
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final WeatherModel result = await _weatherService.getWeather(city);
      _weather = result;
      _currentCity = result.cityName;
      _errorMessage = null;

      // 3. Save valid city to local storage
      await _storageService.saveLastCity(result.cityName);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    await fetchWeather(_currentCity);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
