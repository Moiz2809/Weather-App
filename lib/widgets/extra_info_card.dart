import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';
import 'weather_detail_tile.dart';

/// Professional Extra Info Card displaying Humidity, Wind Speed, and Feels Like metrics.
/// Features rounded corners, soft ambient shadows, and dynamic Light/Dark mode adaptability.
class ExtraInfoCard extends StatelessWidget {
  final String humidity;
  final String windSpeed;
  final String feelsLike;

  const ExtraInfoCard({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;
        final cardPadding = isWide ? AppSpacing.lg : AppSpacing.md;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: cardPadding,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : AppColors.textPrimary.withValues(alpha: 0.04),
                blurRadius: 16,
                spreadRadius: 0,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: WeatherDetailTile(
                  icon: Icons.water_drop_rounded,
                  iconColor: AppColors.humidity,
                  label: 'Humidity',
                  value: humidity,
                ),
              ),
              _buildVerticalDivider(isDark),
              Expanded(
                child: WeatherDetailTile(
                  icon: Icons.air_rounded,
                  iconColor: AppColors.wind,
                  label: 'Wind Speed',
                  value: windSpeed,
                ),
              ),
              _buildVerticalDivider(isDark),
              Expanded(
                child: WeatherDetailTile(
                  icon: Icons.thermostat_rounded,
                  iconColor: AppColors.sunny,
                  label: 'Feels Like',
                  value: feelsLike,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      height: 44,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      color: isDark ? const Color(0xFF334155) : AppColors.border.withValues(alpha: 0.6),
    );
  }
}
