import 'package:flutter/material.dart';
import '../models/weather_alert_model.dart';
import '../utils/theme.dart';

/// Reusable Severe Weather Alert Card Widget.
/// Automatically hides itself (`SizedBox.shrink()`) when no alerts exist in the payload.
class AlertCard extends StatelessWidget {
  final List<WeatherAlertModel>? alerts;

  const AlertCard({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    // Hide card completely if alerts list is null or empty
    if (alerts == null || alerts!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: alerts!.map((alert) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: alert.severityColor.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: alert.severityColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Warning Icon, Title & Severity Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: alert.severityColor,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Start and End time timestamps
                        Text(
                          'Active: ${alert.startTime} - ${alert.endTime}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: alert.severityColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Severity Pill Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: alert.severityColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      alert.severity.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Alert Description Text
              Text(
                alert.description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
