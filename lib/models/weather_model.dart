import 'package:flutter/material.dart';

/// Data Model representing current weather information for a city.
/// Provides JSON serialization, deserialization, and UI getters.
class WeatherModel {
  /// Name of the searched city/location (e.g. "London")
  final String cityName;

  /// Current temperature value in numerical degrees (e.g. 24.5)
  final double temperature;

  /// Main weather condition description (e.g. "Sunny", "Clear", "Rainy")
  final String condition;

  /// Relative humidity percentage value (0 to 100%)
  final int humidity;

  /// Wind speed measurement value (e.g. 12.5 km/h)
  final double windSpeed;

  /// Perceived temperature ("Feels Like") value in numerical degrees (e.g. 26.0)
  final double feelsLike;

  /// Icon code or icon identifier representing the weather condition (e.g. "01d")
  final String weatherIcon;

  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.weatherIcon,
  });

  /// Factory constructor to parse WeatherModel from a JSON map safely.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] as String? ?? json['cityName'] as String? ?? 'Unknown Location',
      temperature: (json['main'] != null ? json['main']['temp'] : json['temperature'])?.toDouble() ?? 0.0,
      condition: (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['main'] as String
          : json['condition'] as String? ?? 'Clear',
      humidity: (json['main'] != null ? json['main']['humidity'] : json['humidity'])?.toInt() ?? 0,
      windSpeed: (json['wind'] != null ? json['wind']['speed'] : json['windSpeed'])?.toDouble() ?? 0.0,
      feelsLike: (json['main'] != null ? json['main']['feels_like'] : json['feelsLike'])?.toDouble() ?? 0.0,
      weatherIcon: (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['icon'] as String
          : json['weatherIcon'] as String? ?? '01d',
    );
  }

  /// Converts WeatherModel instance into a JSON Map for storage.
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'condition': condition,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'feelsLike': feelsLike,
      'weatherIcon': weatherIcon,
    };
  }

  // --- Formatted Getters ---

  String get formattedTemperature => '${temperature.round()}°C';
  String get formattedFeelsLike => '${feelsLike.round()}°C';
  String get formattedHumidity => '$humidity%';
  String get formattedWindSpeed => '${windSpeed.toStringAsFixed(1)} km/h';

  /// Dynamically maps weather condition text to Material 3 Icon Data
  IconData get conditionIcon {
    final lower = condition.toLowerCase();
    if (lower.contains('sun') || lower.contains('clear')) {
      return Icons.wb_sunny_rounded;
    } else if (lower.contains('rain') || lower.contains('drizzle')) {
      return Icons.water_drop_rounded;
    } else if (lower.contains('cloud')) {
      return Icons.cloud_rounded;
    } else if (lower.contains('snow')) {
      return Icons.ac_unit_rounded;
    } else if (lower.contains('thunder') || lower.contains('storm')) {
      return Icons.thunderstorm_rounded;
    }
    return Icons.wb_cloudy_rounded;
  }
}
