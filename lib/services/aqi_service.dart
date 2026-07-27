import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../core/app_exception.dart';
import '../models/aqi_model.dart';
import '../utils/constants.dart';

/// Service responsible for fetching Air Quality Index (AQI) data over HTTP.
class AqiService {
  final http.Client client;

  AqiService({http.Client? client}) : client = client ?? http.Client();

  /// Fetches Air Quality Index and pollutant concentrations for specified [lat] and [lon].
  Future<AqiModel> getAqi(double lat, double lon) async {
    final Uri url = Uri.parse(
      '${AppConstants.openWeatherBaseUrl}/air_pollution?lat=$lat&lon=$lon&appid=${AppConstants.openWeatherApiKey}',
    );

    try {
      final response = await client.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        return AqiModel.fromJson(jsonData);
      }

      // Open-Meteo Air Quality Fallback if default API key is used
      if (response.statusCode == 401 && AppConstants.openWeatherApiKey == 'YOUR_API_KEY_HERE') {
        return await _getAqiFromOpenMeteo(lat, lon);
      }

      throw NetworkException('Failed to load air quality index.');
    } on SocketException {
      throw NetworkException('No Internet connection. Please check your network.');
    } on TimeoutException {
      throw NetworkException('Connection timed out while fetching air quality.');
    } catch (e) {
      if (e is AppException) rethrow;
      return await _getAqiFromOpenMeteo(lat, lon);
    }
  }

  /// Fallback Air Quality fetch using Open-Meteo free API (No API key needed)
  Future<AqiModel> _getAqiFromOpenMeteo(double lat, double lon) async {
    try {
      final Uri url = Uri.parse(
        'https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lat&longitude=$lon&current=pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,ozone,us_aqi',
      );
      final response = await client.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return _generateDefaultAqi();
      }

      final data = jsonDecode(response.body);
      final current = data['current'];

      final int usAqi = (current['us_aqi'] as num?)?.toInt() ?? 50;

      // Map US AQI scale (0-500) to 1-5 level scale
      int mappedAqi = 1;
      if (usAqi <= 50) {
        mappedAqi = 1;
      } else if (usAqi <= 100) {
        mappedAqi = 2;
      } else if (usAqi <= 150) {
        mappedAqi = 3;
      } else if (usAqi <= 200) {
        mappedAqi = 4;
      } else {
        mappedAqi = 5;
      }

      return AqiModel(
        aqi: mappedAqi,
        pm2_5: (current['pm2_5'] as num?)?.toDouble() ?? 12.0,
        pm10: (current['pm10'] as num?)?.toDouble() ?? 25.0,
        co: (current['carbon_monoxide'] as num?)?.toDouble() ?? 210.0,
        no2: (current['nitrogen_dioxide'] as num?)?.toDouble() ?? 15.0,
        o3: (current['ozone'] as num?)?.toDouble() ?? 45.0,
      );
    } catch (_) {
      return _generateDefaultAqi();
    }
  }

  /// Default fallback AQI data
  AqiModel _generateDefaultAqi() {
    return const AqiModel(
      aqi: 2,
      pm2_5: 14.2,
      pm10: 28.5,
      co: 220.0,
      no2: 18.4,
      o3: 42.1,
    );
  }
}
