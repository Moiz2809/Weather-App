/// App Constants used across the Weather application.
/// Keeping constants centralized makes it easy to maintain and configure.
class AppConstants {
  // App Title
  static const String appName = 'SkyWatch Weather';

  // API Configuration
  // OpenWeatherMap free API key (or Open-Meteo fallback)
  static const String openWeatherApiKey = 'YOUR_API_KEY_HERE';
  static const String openWeatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // Open-Meteo Free API (No key required - great default for instant testing!)
  static const String openMeteoGeoUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String openMeteoWeatherUrl = 'https://api.open-meteo.com/v1/forecast';

  // Default location
  static const String defaultCity = 'London';

  // SharedPreferences Keys
  static const String keyLastCity = 'last_searched_city';
  static const String keyRecentCities = 'recent_cities';
  static const String keyTemperatureUnit = 'is_celsius';
  static const String keyThemeMode = 'is_dark_mode';

  // Design & Spacing Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 20.0;
}
