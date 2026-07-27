import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../core/app_exception.dart';
import '../models/weather_model.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';
import '../utils/validator.dart';

/// WeatherProvider manages application state for weather data, loading status,
/// error messages, temperature units, GPS location, and persistent search history.
class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final StorageService _storageService;
  final LocationService _locationService;

  // --- Private State Variables ---
  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentCity = AppConstants.defaultCity;
  bool _isCelsius = true;

  /// Constructor with dependency injection for services.
  WeatherProvider({
    WeatherService? weatherService,
    StorageService? storageService,
    LocationService? locationService,
  })  : _weatherService = weatherService ?? WeatherService(),
        _storageService = storageService ?? StorageService(),
        _locationService = locationService ?? LocationService();

  // --- Public Getters ---
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasData => _weather != null && !_isLoading;
  String get currentCity => _currentCity;
  bool get isCelsius => _isCelsius;

  // --- Unit Toggle Action ---
  void toggleTemperatureUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
  }

  // --- GPS Location Action ---

  /// Requests location permissions, retrieves current GPS coordinates, and fetches weather.
  Future<void> fetchWeatherForCurrentLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Get current latitude and longitude from LocationService
      final Position position = await _locationService.getCurrentLocation();

      // 2. Fetch weather using GPS coordinates
      final WeatherModel result = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      _weather = result;
      _currentCity = result.cityName;
      _errorMessage = null;

      // 3. Persist city name to local storage
      await _storageService.saveLastCity(result.cityName);
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Unable to fetch weather for your location: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
    final String? validationError = CityValidator.validate(city);
    if (validationError != null) {
      _errorMessage = validationError;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final WeatherModel result = await _weatherService.getWeather(city);
      _weather = result;
      _currentCity = result.cityName;
      _errorMessage = null;

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
