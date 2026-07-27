import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../core/app_exception.dart';
import '../models/hourly_forecast_model.dart';
import '../models/weather_model.dart';
import '../utils/constants.dart';

/// WeatherService handles network API requests to fetch weather data and hourly forecasts.
class WeatherService {
  final http.Client client;

  WeatherService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches weather data for a given [city] name.
  Future<WeatherModel> getWeather(String city) async {
    final sanitizedCity = city.trim();

    if (sanitizedCity.isEmpty) {
      throw AppException('City name cannot be empty.');
    }

    final Uri url = Uri.parse(
      '${AppConstants.openWeatherBaseUrl}/weather?q=${Uri.encodeComponent(sanitizedCity)}&units=metric&appid=${AppConstants.openWeatherApiKey}',
    );

    try {
      final response = await client.get(url).timeout(
        const Duration(seconds: 10),
      );

      switch (response.statusCode) {
        case 200:
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          return WeatherModel.fromJson(jsonData);

        case 404:
        case 400:
          throw CityNotFoundException(sanitizedCity);

        case 500:
        case 502:
        case 503:
        case 504:
          throw NetworkException('Server error (${response.statusCode}). Please try again later.');

        default:
          if (response.statusCode == 401 && AppConstants.openWeatherApiKey == 'YOUR_API_KEY_HERE') {
            return await _getWeatherFromOpenMeteo(sanitizedCity);
          }
          throw NetworkException('Failed to load weather (Error ${response.statusCode}).');
      }
    } on SocketException {
      throw NetworkException('No Internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } on FormatException {
      throw NetworkException('Invalid data received from weather service.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetches weather data by device GPS [lat] and [lon].
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    final Uri url = Uri.parse(
      '${AppConstants.openWeatherBaseUrl}/weather?lat=$lat&lon=$lon&units=metric&appid=${AppConstants.openWeatherApiKey}',
    );

    try {
      final response = await client.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return WeatherModel.fromJson(jsonData);
      }

      if (response.statusCode == 401 && AppConstants.openWeatherApiKey == 'YOUR_API_KEY_HERE') {
        return await _getWeatherFromOpenMeteoCoords(lat, lon, 'My Location');
      }

      throw NetworkException('Failed to load weather for current location.');
    } on SocketException {
      throw NetworkException('No Internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is AppException) rethrow;
      return await _getWeatherFromOpenMeteoCoords(lat, lon, 'My Location');
    }
  }

  /// Fallback Open-Meteo fetch using latitude & longitude including 24-hour forecast
  Future<WeatherModel> _getWeatherFromOpenMeteoCoords(double lat, double lon, [String label = 'My Location']) async {
    try {
      final weatherUrl = Uri.parse(
        '${AppConstants.openMeteoWeatherUrl}?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m&hourly=temperature_2m&forecast_days=2',
      );
      final weatherResponse = await client.get(weatherUrl).timeout(const Duration(seconds: 8));

      if (weatherResponse.statusCode != 200) {
        throw NetworkException('Failed to fetch weather data.');
      }

      final weatherData = jsonDecode(weatherResponse.body);
      final current = weatherData['current'];
      final double temp = (current['temperature_2m'] as num).toDouble();

      // Extract 24-hour hourly points from Open-Meteo
      final List<HourlyForecastPoint> hourlyPoints = [];
      if (weatherData['hourly'] != null &&
          weatherData['hourly']['time'] != null &&
          weatherData['hourly']['temperature_2m'] != null) {
        final List times = weatherData['hourly']['time'];
        final List temps = weatherData['hourly']['temperature_2m'];

        // Extract 8 intervals (every 3 hours) for the next 24 hours
        final int limit = times.length > 24 ? 24 : times.length;
        for (int i = 0; i < limit; i += 3) {
          final String rawTime = times[i].toString(); // e.g. "2026-07-27T14:00"
          final String hourStr = rawTime.contains('T')
              ? rawTime.split('T')[1].substring(0, 5)
              : '00:00';

          hourlyPoints.add(
            HourlyForecastPoint(
              time: hourStr,
              temperature: (temps[i] as num).toDouble(),
            ),
          );
        }
      }

      return WeatherModel(
        cityName: label,
        temperature: temp,
        condition: _mapWeatherCodeToCondition((current['weather_code'] as num).toInt()),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        windSpeed: (current['wind_speed_10m'] as num).toDouble(),
        feelsLike: (current['apparent_temperature'] as num).toDouble(),
        weatherIcon: '01d',
        hourlyForecast: hourlyPoints,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw NetworkException('Unable to fetch weather for coordinates.');
    }
  }

  /// Backup free API fetch using Open-Meteo
  Future<WeatherModel> _getWeatherFromOpenMeteo(String city) async {
    try {
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

      return await _getWeatherFromOpenMeteoCoords(lat, lon, foundCity);
    } on SocketException {
      throw NetworkException('No Internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Connection timed out. Please try again.');
    } catch (e) {
      if (e is AppException) rethrow;
      throw CityNotFoundException(city);
    }
  }

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
