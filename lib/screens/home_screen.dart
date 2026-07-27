import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/weather_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/extra_info_card.dart';
import '../widgets/hourly_chart_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/weather_card.dart';

/// Connected & Fully Responsive Home Screen with 24-Hour Hourly Temperature Chart.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadSavedCityOrFallback();
    });
  }

  void _onSearch(String query) {
    FocusScope.of(context).unfocus();
    context.read<WeatherProvider>().fetchWeather(query);
  }

  void _fetchCurrentLocation() {
    FocusScope.of(context).unfocus();
    context.read<WeatherProvider>().fetchWeatherForCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final maxContentWidth = Responsive.getMaxContentWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // 1. Current GPS Location Action Button
          Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.my_location_rounded),
                tooltip: 'Use Current Location',
                onPressed: provider.isLoading ? null : _fetchCurrentLocation,
              );
            },
          ),

          // 2. Dark Mode Toggle Switch Button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                onPressed: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
              );
            },
          ),

          // 3. Weather Refresh Button
          Consumer<WeatherProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Refresh Weather',
                onPressed: provider.isLoading
                    ? null
                    : () => provider.refreshWeather(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxContentWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      // Search Bar & "Use Current Location" Button Row
                      Consumer<WeatherProvider>(
                        builder: (context, provider, child) {
                          return Row(
                            children: [
                              Expanded(
                                child: SearchBarWidget(
                                  onSearch: _onSearch,
                                  initialQuery: provider.currentCity,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              InkWell(
                                onTap: provider.isLoading ? null : _fetchCurrentLocation,
                                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                    border: Border.all(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.my_location_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Animated Weather Body Switcher
                      Expanded(
                        child: Consumer<WeatherProvider>(
                          builder: (context, provider, child) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              switchInCurve: Curves.easeIn,
                              switchOutCurve: Curves.easeOut,
                              child: _buildBodyContent(provider),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Selects and builds body widget based on WeatherProvider state
  Widget _buildBodyContent(WeatherProvider provider) {
    if (provider.isLoading) {
      return LoadingWidget(
        key: const ValueKey('loading'),
        message: 'Fetching weather for "${provider.currentCity}"...',
      );
    }

    if (provider.hasError) {
      return AppErrorWidget.fromMessage(
        key: const ValueKey('error'),
        message: provider.errorMessage!,
        onRetry: () => provider.refreshWeather(),
      );
    }

    if (provider.hasData) {
      final weather = provider.weather!;
      final isCelsius = provider.isCelsius;

      return RefreshIndicator(
        key: const ValueKey('weather_data'),
        onRefresh: () => provider.refreshWeather(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Weather Hero Card
              WeatherCard(
                cityName: weather.cityName,
                country: 'Weather Report',
                temperature: weather.getFormattedTemperature(isCelsius),
                condition: weather.condition,
                date: 'Today',
                icon: weather.conditionIcon,
                isCelsius: isCelsius,
                onUnitToggle: () => provider.toggleTemperatureUnit(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Smooth 24-Hour Temperature Line Chart Widget
              HourlyChartWidget(
                points: weather.hourlyForecast,
                isCelsius: isCelsius,
              ),
              const SizedBox(height: AppSpacing.lg),

              // 3. Extra Weather Metrics Card
              ExtraInfoCard(
                humidity: weather.formattedHumidity,
                windSpeed: weather.formattedWindSpeed,
                feelsLike: weather.getFormattedFeelsLike(isCelsius),
              ),
            ],
          ),
        ),
      );
    }

    return const EmptyStateWidget(key: ValueKey('empty'));
  }
}
