import 'package:flutter/material.dart';

/// Centralized Color Palette for the Weather App.
/// Uses modern, vibrant weather-themed colors.
class AppColors {
  // Main Brand Colors (Sky & Weather Tones)
  static const Color primary = Color(0xFF2E63E5);      // Deep Sky Blue
  static const Color secondary = Color(0xFF00D2FF);    // Vibrant Cyan
  static const Color accent = Color(0xFF38BDF8);       // Bright Sky Blue

  // Light Theme Surfaces & Backgrounds
  static const Color background = Color(0xFFF8FAFC);   // Soft Light Blue-Grey
  static const Color surface = Color(0xFFFFFFFF);      // Pure White Card Surface
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Light Grey Container

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);  // Deep Slate (High contrast)
  static const Color textSecondary = Color(0xFF64748B);// Medium Slate
  static const Color textMuted = Color(0xFF94A3B8);    // Soft Slate

  // Weather Condition Indicators
  static const Color sunny = Color(0xFFF59E0B);        // Amber / Sun Gold
  static const Color rainy = Color(0xFF3B82F6);        // Rain Blue
  static const Color cloudy = Color(0xFF64748B);       // Cloud Grey
  static const Color stormy = Color(0xFF6366F1);       // Thunderstorm Indigo
  static const Color snowy = Color(0xFF38BDF8);        // Snow Ice Cyan

  // Weather Metric Badges
  static const Color humidity = Color(0xFF0EA5E9);     // Water Droplet Blue
  static const Color wind = Color(0xFF14B8A6);         // Wind Teal
  static const Color pressure = Color(0xFF8B5CF6);     // Barometer Purple
  static const Color uvIndex = Color(0xFFF97316);      // UV Orange

  // Interactive & State Colors
  static const Color border = Color(0xFFE2E8F0);        // Subtle Input Border
  static const Color divider = Color(0xFFCBD5E1);       // Divider Line
  static const Color error = Color(0xFFEF4444);         // Alert / Error Red
  static const Color success = Color(0xFF10B981);       // Success Green
}
