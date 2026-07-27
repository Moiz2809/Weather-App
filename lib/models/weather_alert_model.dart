import 'package:flutter/material.dart';

/// Data Model representing severe weather alerts (e.g., Storm Warnings, Flood Watches).
class WeatherAlertModel {
  /// Alert event title (e.g. "Severe Thunderstorm Warning")
  final String title;

  /// Full description of the weather alert
  final String description;

  /// Alert severity rating (e.g. "Warning", "Watch", "Extreme", "Severe", "Moderate")
  final String severity;

  /// Start timestamp label (e.g. "14:00 Today")
  final String startTime;

  /// End timestamp label (e.g. "20:00 Today")
  final String endTime;

  const WeatherAlertModel({
    required this.title,
    required this.description,
    required this.severity,
    required this.startTime,
    required this.endTime,
  });

  /// Factory constructor to parse WeatherAlertModel from JSON safely.
  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      title: json['event'] as String? ?? json['title'] as String? ?? 'Weather Advisory',
      description: json['description'] as String? ?? 'No details provided.',
      severity: json['severity'] as String? ?? json['tags']?[0] as String? ?? 'Warning',
      startTime: _formatTime(json['start']),
      endTime: _formatTime(json['end']),
    );
  }

  /// Helper to convert epoch seconds or ISO strings to readable time
  static String _formatTime(dynamic value) {
    if (value == null) return 'N/A';
    if (value is num) {
      final date = DateTime.fromMillisecondsSinceEpoch((value * 1000).toInt());
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return value.toString();
  }

  /// Converts WeatherAlertModel to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'severity': severity,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  /// Returns status color corresponding to alert severity
  Color get severityColor {
    final lower = severity.toLowerCase();
    if (lower.contains('extreme') || lower.contains('warning') || lower.contains('red')) {
      return const Color(0xFFEF4444); // Bright Red
    } else if (lower.contains('severe') || lower.contains('watch') || lower.contains('orange')) {
      return const Color(0xFFF97316); // Orange
    }
    return const Color(0xFFF59E0B); // Amber / Yellow
  }
}
