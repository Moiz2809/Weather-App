/// Represents a single hourly forecast data point.
class HourlyForecastPoint {
  /// Time label string (e.g. "14:00", "17:00")
  final String time;

  /// Numerical temperature value in degrees (e.g. 23.5)
  final double temperature;

  const HourlyForecastPoint({
    required this.time,
    required this.temperature,
  });

  /// Factory constructor to create HourlyForecastPoint from JSON.
  factory HourlyForecastPoint.fromJson(Map<String, dynamic> json) {
    return HourlyForecastPoint(
      time: json['time'] as String? ?? '00:00',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts HourlyForecastPoint instance to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature': temperature,
    };
  }
}
