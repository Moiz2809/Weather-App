import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';
import 'animated_weather_icon.dart';

/// Professional & Modern Weather Card component with dynamic weather gradients,
/// vector-animated weather condition icons, favorite heart toggle, and unit switcher.
class WeatherCard extends StatelessWidget {
  final String cityName;
  final String country;
  final String temperature;
  final String condition;
  final String date;
  final IconData icon;
  final bool isCelsius;
  final VoidCallback? onUnitToggle;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const WeatherCard({
    super.key,
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.date,
    this.icon = Icons.wb_sunny_rounded,
    this.isCelsius = true,
    this.onUnitToggle,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getConditionGradient(condition);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideCard = constraints.maxWidth > 500;
        final cardPadding = isWideCard ? AppSpacing.xl : AppSpacing.lg;
        final tempFontSize = isWideCard ? 72.0 : 64.0;
        final iconSize = isWideCard ? 48.0 : 40.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.35),
                blurRadius: 24,
                spreadRadius: -2,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row: Location, Date & Dynamic Animated Weather Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                '$cityName, $country',
                                style: TextStyle(
                                  fontSize: isWideCard ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (onFavoriteToggle != null) ...[
                              const SizedBox(width: AppSpacing.xs),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isFavorite
                                      ? const Color(0xFFFF4757)
                                      : Colors.white70,
                                  size: 22,
                                ),
                                tooltip: isFavorite
                                    ? 'Remove from Favorites'
                                    : 'Add to Favorites',
                                onPressed: onFavoriteToggle,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: isWideCard ? 15 : 13,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reusable Animated Weather Icon Badge
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      key: ValueKey(condition),
                      padding: EdgeInsets.all(isWideCard ? AppSpacing.sm : 6.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: AnimatedWeatherIcon(
                        condition: condition,
                        size: iconSize,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: isWideCard ? AppSpacing.xl : AppSpacing.lg),

              // Temperature Row + Unit Toggle Pill & Condition Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        temperature,
                        style: TextStyle(
                          fontSize: tempFontSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (onUnitToggle != null) ...[
                        GestureDetector(
                          onTap: onUnitToggle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '°C',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isCelsius ? FontWeight.w800 : FontWeight.normal,
                                    color: isCelsius ? Colors.white : Colors.white60,
                                  ),
                                ),
                                const Text(
                                  ' | ',
                                  style: TextStyle(color: Colors.white60, fontSize: 13),
                                ),
                                Text(
                                  '°F',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: !isCelsius ? FontWeight.w800 : FontWeight.normal,
                                    color: !isCelsius ? Colors.white : Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWideCard ? AppSpacing.lg : AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          condition,
                          style: TextStyle(
                            fontSize: isWideCard ? 16 : 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Color> _getConditionGradient(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sun') || lower.contains('clear')) {
      return const [Color(0xFF2563EB), Color(0xFF3B82F6), Color(0xFF60A5FA)];
    } else if (lower.contains('rain') || lower.contains('drizzle')) {
      return const [Color(0xFF1E293B), Color(0xFF334155), Color(0xFF475569)];
    } else if (lower.contains('cloud')) {
      return const [Color(0xFF475569), Color(0xFF64748B), Color(0xFF94A3B8)];
    } else if (lower.contains('snow')) {
      return const [Color(0xFF0284C7), Color(0xFF38BDF8), Color(0xFF7DD3FC)];
    } else if (lower.contains('thunder') || lower.contains('storm')) {
      return const [Color(0xFF312E81), Color(0xFF4338CA), Color(0xFF6366F1)];
    }
    return const [AppColors.primary, Color(0xFF1D4ED8)];
  }
}
