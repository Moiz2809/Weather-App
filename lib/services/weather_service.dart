import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../core/app_exception.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';

/// WeatherService handles network API requests to fetch weather data.
class WeatherService {
  final http.Client client;

  /// Constructor accepting an optional http.Client (useful for testing).
  WeatherService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches weather data for a given [city] name.
  /// Throws specific [AppException] subclasses on network or API failures.
  Future<WeatherModel> getWeather(String city) async {
    // 1. Sanitize city input string (remove leading/trailing whitespace)
    final sanitizedCity = city.trim();

    // 2. Validate empty city query
    if (sanitizedCity.isEmpty) {
      throw AppException('City name cannot be empty.');
    }

    // 3. Construct API URL endpoint
    final Uri url = Uri.parse(
      '${AppConstants.openWeatherBaseUrl}/weather?q=${Uri.encodeComponent(sanitizedCity)}&units=metric&appid=${AppConstants.openWeatherApiKey}',
    );

    try {
      // 4. Send HTTP GET request with a 10-second timeout
      final response = await client.get(url).timeout(
        const Duration(seconds: 10),
      );

      // 5. Inspect HTTP Response Status Code
      switch (response.statusCode) {
        case 200:
          // Success: Parse JSON response body into WeatherModel instance
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          return WeatherModel.fromJson(jsonData);

        case 404:
        case 400:
          // Invalid City / City Not Found Error
          throw CityNotFoundException(sanitizedCity);

        case 500:
        case 502:
        case 503:
        case 504:
          // Server Error
          throw NetworkException('Server error (${response.statusCode}). Please try again later.');

        default:
          // Handle other HTTP failure codes (e.g. 401 Unauthorized API key)
          if (response.statusCode == 401 && AppConstants.openWeatherApiKey == 'YOUR_API_KEY_HERE') {
            // Friendly fallback parser for Open-Meteo (No API key required!)
            return await _getWeatherFromOpenMeteo(sanitizedCity);
          }
          throw NetworkException('Failed to load weather (Error ${response.statusCode}).');
      }
    } on SocketException {
      // Handle No Internet Connection
      throw NetworkException('No Internet connection. Please check your network.');
    } on TimeoutException {
      // Handle Request Timeout
      throw NetworkException('Connection timed out. Please try again.');
    } on FormatException {
      // Handle Invalid JSON format response
      throw NetworkException('Invalid data received from weather service.');
    } catch (e) {
      // Rethrow AppException or wrap unknown exceptions
      if (e is AppException) rethrow;
      throw NetworkException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Backup free API fetch using Open-Meteo (requires NO API key!)
  /// This ensures instant functionality even before user enters an OpenWeather key.
  Future<WeatherModel> _getWeatherFromOpenMeteo(String city) async {
    try {
      // Geocoding step: Search city to get latitude & longitude
      final geoUrl = Uri.parse('${AppConstants.openMeteoGeoUrl}?name=${Uri.encodeComponent(city)}&count=1&language=en&format=json');
      final geoResponse = await client.get(geoUrl).timeout(const Duration(seconds: 8));

      if (geoResponse.statusCode != 200) {
        throw CityNotFoundException(city);
      }

      final geoData = jsonDecode(geoResponse.body);
      if (geoData['results'] == null || (geoData['results'] as List).isEmpty) {
        throw CityNotFoundException(city);
      }

      final location = geoData['results'][0];
      final double lat = (location['latitude'] as num).toDouble();
      final double lon = (location['longitude'] as num).toDouble();
      final String foundCity = location['name'] as String? ?? city;

      // Weather step: Fetch weather details for lat & lon
      final weatherUrl = Uri.parse(
        '${AppConstants.openMeteoWeatherUrl}?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
      );
      final weatherResponse = await client.get(weatherUrl).timeout(const Duration(seconds: 8));

      if (weatherResponse.statusCode != 200) {
        throw NetworkException('Failed to fetch weather data.');
      }

      final weatherData = jsonDecode(weatherResponse.body);
      final current = weatherData['current'];

      return WeatherModel(
        cityName: foundCity,
        temperature: (current['temperature_2m'] as num).toDouble(),
        condition: _mapWeatherCodeToCondition((current['weather_code'] as num).toInt()),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        windSpeed: (current['wind_speed_10m'] as num).toDouble(),
        feelsLike: (current['apparent_temperature'] as num).toDouble(),
        weatherIcon: '01d',
      );
    } on SocketException {
      throw NetworkException('No Internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw CityNotFoundException(city);
    }
  }

  /// Maps WMO weather codes to human-readable condition string
  String _mapWeatherCodeToCondition(int code) {
    if (code == 0) return 'Clear';
    if (code >= 1 && code <= 3) return 'Partly Cloudy';
    if (code >= 45 && code <= 48) return 'Foggy';
    if (code >= 51 && code <= 67) return 'Rainy';
    if (code >= 71 && code <= 77) return 'Snowy';
    if (code >= 80 && code <= 82) return 'Showers';
    if (code >= 95) return 'Thunderstorm';
    return 'Cloudy';
  }
}
