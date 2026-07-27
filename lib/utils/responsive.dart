import 'package:flutter/material.dart';

/// Helper utility for responsive breakpoints across Mobile, Tablet, and Desktop screen sizes.
class Responsive {
  /// Returns true if device screen width is smaller than 600 pixels (Android Phones).
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  /// Returns true if device screen width is between 600 and 1024 pixels (Tablets / Foldables).
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  /// Returns true if device screen width is 1024 pixels or wider.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  /// Returns dynamic horizontal padding based on screen width.
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 12.0;       // Compact Android Phones
    if (width < 600) return 16.0;       // Standard Android Phones
    if (width < 1024) return 24.0;      // Tablets
    return 32.0;                         // Large Tablets / Desktop
  }

  /// Returns dynamic max width constraint for content containers.
  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return 900.0;
    if (width >= 600) return 720.0;
    return double.infinity;
  }
}
