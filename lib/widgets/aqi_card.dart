import 'package:flutter/material.dart';
import '../models/aqi_model.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';

/// Reusable Air Quality Index (AQI) Card Widget.
/// Displays AQI Level (1-5), status label badge, and pollutant details (PM2.5, PM10, CO, NO2, O3).
class AqiCard extends StatelessWidget {
  final AqiModel? aqi;
  final bool isLoading;

  const AqiCard({
    super.key,
    required this.aqi,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : AppColors.border.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: Title Icon + AQI Rating Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.air_rounded,
                    color: AppColors.wind,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Air Quality Index (AQI)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Status Rating Badge
              if (aqi != null && !isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: aqi!.aqiColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: aqi!.aqiColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: aqi!.aqiColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${aqi!.aqiLabel} (${aqi!.aqi}/5)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: aqi!.aqiColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Loading State Indicator inside Card
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            )
          else if (aqi == null)
            Text(
              'Air Quality data unavailable for this location.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
              ),
            )
          else
            // 5 Pollutant Concentration Items Grid
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _PollutantItem(
                  name: 'PM2.5',
                  value: '${aqi!.pm2_5.toStringAsFixed(1)} μg/m³',
                  description: 'Fine Particulates',
                ),
                _PollutantItem(
                  name: 'PM10',
                  value: '${aqi!.pm10.toStringAsFixed(1)} μg/m³',
                  description: 'Coarse Dust',
                ),
                _PollutantItem(
                  name: 'CO',
                  value: '${aqi!.co.toStringAsFixed(1)} μg/m³',
                  description: 'Carbon Monoxide',
                ),
                _PollutantItem(
                  name: 'NO₂',
                  value: '${aqi!.no2.toStringAsFixed(1)} μg/m³',
                  description: 'Nitrogen Dioxide',
                ),
                _PollutantItem(
                  name: 'O₃',
                  value: '${aqi!.o3.toStringAsFixed(1)} μg/m³',
                  description: 'Ozone',
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Helper sub-widget for individual pollutant metric tile.
class _PollutantItem extends StatelessWidget {
  final String name;
  final String value;
  final String description;

  const _PollutantItem({
    required this.name,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.5)
            : AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isDark
              ? const Color(0xFF334155)
              : AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.accent : AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF94A3B8) : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
