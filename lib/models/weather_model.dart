import 'package:flutter/material.dart';
import 'hourly_forecast_model.dart';
import 'weather_alert_model.dart';

/// Data Model representing current weather information, location coordinates, 24-hour forecast, and weather alerts.
class WeatherModel {
  /// Name of the searched city/location (e.g. "London")
  final String cityName;

  /// Current temperature value in Celsius (e.g. 24.5)
  final double temperature;

  /// Main weather condition description (e.g. "Sunny", "Clear", "Rainy")
  final String condition;

  /// Relative humidity percentage value (0 to 100%)
  final int humidity;

  /// Wind speed measurement value (e.g. 12.5 km/h)
  final double windSpeed;

  /// Perceived temperature ("Feels Like") value in Celsius (e.g. 26.0)
  final double feelsLike;

  /// Icon code or icon identifier representing the weather condition (e.g. "01d")
  final String weatherIcon;

  /// Latitude coordinate of the location
  final double latitude;

  /// Longitude coordinate of the location
  final double longitude;

  /// List of 24-hour hourly temperature forecast data points
  final List<HourlyForecastPoint> hourlyForecast;

  /// List of active severe weather alerts (empty if no alerts)
  final List<WeatherAlertModel> alerts;

  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.weatherIcon,
    required this.latitude,
    required this.longitude,
    required this.hourlyForecast,
    this.alerts = const [],
  });

  /// Factory constructor to parse WeatherModel from a JSON map safely.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final double temp = (json['main'] != null ? json['main']['temp'] : json['temperature'])?.toDouble() ?? 0.0;

    // Parse latitude and longitude
    double lat = 51.5074;
    double lon = -0.1278;
    if (json['coord'] != null) {
      lat = (json['coord']['lat'] as num?)?.toDouble() ?? 51.5074;
      lon = (json['coord']['lon'] as num?)?.toDouble() ?? -0.1278;
    } else {
      lat = (json['latitude'] as num?)?.toDouble() ?? 51.5074;
      lon = (json['longitude'] as num?)?.toDouble() ?? -0.1278;
    }

    // Parse hourly forecast list if present in JSON
    List<HourlyForecastPoint> hourly = [];
    if (json['hourlyForecast'] != null && json['hourlyForecast'] is List) {
      hourly = (json['hourlyForecast'] as List)
          .map((item) => HourlyForecastPoint.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (hourly.isEmpty) {
      hourly = _generateSampleHourlyData(temp);
    }

    // Parse severe weather alerts if present in JSON
    List<WeatherAlertModel> alertList = [];
    if (json['alerts'] != null && json['alerts'] is List) {
      alertList = (json['alerts'] as List)
          .map((item) => WeatherAlertModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return WeatherModel(
      cityName: json['name'] as String? ?? json['cityName'] as String? ?? 'Unknown Location',
      temperature: temp,
      condition: (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['main'] as String
          : json['condition'] as String? ?? 'Clear',
      humidity: (json['main'] != null ? json['main']['humidity'] : json['humidity'])?.toInt() ?? 0,
      windSpeed: (json['wind'] != null ? json['wind']['speed'] : json['windSpeed'])?.toDouble() ?? 0.0,
      feelsLike: (json['main'] != null ? json['main']['feels_like'] : json['feelsLike'])?.toDouble() ?? 0.0,
      weatherIcon: (json['weather'] != null && (json['weather'] as List).isNotEmpty)
          ? json['weather'][0]['icon'] as String
          : json['weatherIcon'] as String? ?? '01d',
      latitude: lat,
      longitude: lon,
      hourlyForecast: hourly,
      alerts: alertList,
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
      'latitude': latitude,
      'longitude': longitude,
      'hourlyForecast': hourlyForecast.map((e) => e.toJson()).toList(),
      'alerts': alerts.map((e) => e.toJson()).toList(),
    };
  }

  // --- Formatted Getters with Unit Conversion ---

  String getFormattedTemperature(bool isCelsius) {
    if (isCelsius) {
      return '${temperature.round()}°C';
    } else {
      final fahrenheit = (temperature * 9 / 5) + 32;
      return '${fahrenheit.round()}°F';
    }
  }

  String getFormattedFeelsLike(bool isCelsius) {
    if (isCelsius) {
      return '${feelsLike.round()}°C';
    } else {
      final fahrenheit = (feelsLike * 9 / 5) + 32;
      return '${fahrenheit.round()}°F';
    }
  }

  String get formattedTemperature => getFormattedTemperature(true);
  String get formattedFeelsLike => getFormattedFeelsLike(true);

  String get formattedHumidity => '$humidity%';
  String get formattedWindSpeed => '${windSpeed.toStringAsFixed(1)} km/h';

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

  /// Generates a realistic 24-hour temperature curve around base temperature.
  static List<HourlyForecastPoint> _generateSampleHourlyData(double baseTemp) {
    final List<HourlyForecastPoint> points = [];
    final now = DateTime.now();

    for (int i = 0; i < 8; i++) {
      final hourTime = now.add(Duration(hours: i * 3));
      final String timeStr = '${hourTime.hour.toString().padLeft(2, '0')}:00';

      double variation = 0;
      if (i == 1 || i == 2) {
        variation = 2.0;
      } else if (i == 3 || i == 4) {
        variation = 0.5;
      } else if (i == 5 || i == 6) {
        variation = -2.5;
      } else {
        variation = -1.0;
      }

      points.add(
        HourlyForecastPoint(
          time: timeStr,
          temperature: baseTemp + variation,
        ),
      );
    }
    return points;
  }
}
