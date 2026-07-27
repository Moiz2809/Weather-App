import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../providers/weather_provider.dart';
import '../utils/colors.dart';
import '../utils/theme.dart';
import '../widgets/empty_state_widget.dart';

/// Screen displaying the user's saved Favorite Cities.
/// Tapping a city loads its weather; tapping delete removes it from favorites.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Cities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            final favorites = favoritesProvider.favoriteCities;

            // Empty State View when no favorite cities exist
            if (favorites.isEmpty) {
              return const EmptyStateWidget(
                title: 'No Favorite Cities Saved',
                subtitle: 'Tap the heart icon on any weather card to save your favorite cities here.',
                icon: Icons.favorite_border_rounded,
              );
            }

            // List of Favorite Cities
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final city = favorites[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.2)
                            : AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : AppColors.border.withValues(alpha: 0.6),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_city_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      city,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Tap to load live weather',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                      ),
                      tooltip: 'Remove from Favorites',
                      onPressed: () {
                        favoritesProvider.removeFavorite(city);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Removed "$city" from favorites.'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      // Fetch weather for selected city and return to home screen
                      context.read<WeatherProvider>().fetchWeather(city);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
