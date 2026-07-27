import 'package:flutter/material.dart';

/// Data Model representing Air Quality Index (AQI) and pollutant concentrations.
class AqiModel {
  /// Air Quality Index Level (1 = Good, 2 = Fair, 3 = Moderate, 4 = Poor, 5 = Very Poor)
  final int aqi;

  /// Fine Particulate Matter (PM2.5) in μg/m³
  final double pm2_5;

  /// Coarse Particulate Matter (PM10) in μg/m³
  final double pm10;

  /// Carbon Monoxide (CO) in μg/m³
  final double co;

  /// Nitrogen Dioxide (NO2) in μg/m³
  final double no2;

  /// Ozone (O3) in μg/m³
  final double o3;

  const AqiModel({
    required this.aqi,
    required this.pm2_5,
    required this.pm10,
    required this.co,
    required this.no2,
    required this.o3,
  });

  /// Factory constructor to parse AqiModel from OpenWeatherMap Air Pollution API JSON response.
  factory AqiModel.fromJson(Map<String, dynamic> json) {
    int mainAqi = 1;
    double coVal = 0.0;
    double no2Val = 0.0;
    double o3Val = 0.0;
    double pm10Val = 0.0;
    double pm2_5Val = 0.0;

    // Parse OpenWeatherMap response format: json['list'][0]
    if (json['list'] != null && (json['list'] as List).isNotEmpty) {
      final item = json['list'][0];
      if (item['main'] != null && item['main']['aqi'] != null) {
        mainAqi = (item['main']['aqi'] as num).toInt();
      }
      if (item['components'] != null) {
        final comp = item['components'];
        coVal = (comp['co'] as num?)?.toDouble() ?? 0.0;
        no2Val = (comp['no2'] as num?)?.toDouble() ?? 0.0;
        o3Val = (comp['o3'] as num?)?.toDouble() ?? 0.0;
        pm10Val = (comp['pm10'] as num?)?.toDouble() ?? 0.0;
        pm2_5Val = (comp['pm2_5'] as num?)?.toDouble() ?? 0.0;
      }
    } else {
      // Direct parsing fallback
      mainAqi = (json['aqi'] as num?)?.toInt() ?? 1;
      coVal = (json['co'] as num?)?.toDouble() ?? 0.0;
      no2Val = (json['no2'] as num?)?.toDouble() ?? 0.0;
      o3Val = (json['o3'] as num?)?.toDouble() ?? 0.0;
      pm10Val = (json['pm10'] as num?)?.toDouble() ?? 0.0;
      pm2_5Val = (json['pm2_5'] as num?)?.toDouble() ?? 0.0;
    }

    return AqiModel(
      aqi: mainAqi.clamp(1, 5),
      pm2_5: pm2_5Val,
      pm10: pm10Val,
      co: coVal,
      no2: no2Val,
      o3: o3Val,
    );
  }

  /// Converts AqiModel instance into a JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'aqi': aqi,
      'pm2_5': pm2_5,
      'pm10': pm10,
      'co': co,
      'no2': no2,
      'o3': o3,
    };
  }

  // --- Helper Getters for User-Friendly Labels & Colors ---

  /// Returns user-friendly AQI rating label.
  String get aqiLabel {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Moderate';
    }
  }

  /// Returns status color matching the AQI severity level.
  Color get aqiColor {
    switch (aqi) {
      case 1:
        return const Color(0xFF10B981); // Emerald Green
      case 2:
        return const Color(0xFF84CC16); // Lime Green
      case 3:
        return const Color(0xFFF59E0B); // Amber / Yellow
      case 4:
        return const Color(0xFFEF4444); // Red
      case 5:
        return const Color(0xFF8B5CF6); // Purple
      default:
        return const Color(0xFFF59E0B);
    }
  }
}
