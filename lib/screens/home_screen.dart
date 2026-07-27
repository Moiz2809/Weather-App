import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/extra_info_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/weather_card.dart';

/// Connected & Fully Responsive Home Screen with smooth state transition animations.
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
                      // 1. Search Bar Input
                      Consumer<WeatherProvider>(
                        builder: (context, provider, child) {
                          return SearchBarWidget(
                            onSearch: _onSearch,
                            initialQuery: provider.currentCity,
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // 2. Animated Weather Body State Switcher
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
    // State 1: Loading Indicator
    if (provider.isLoading) {
      return LoadingWidget(
        key: const ValueKey('loading'),
        message: 'Fetching weather for "${provider.currentCity}"...',
      );
    }

    // State 2: Error State View
    if (provider.hasError) {
      return AppErrorWidget.fromMessage(
        key: const ValueKey('error'),
        message: provider.errorMessage!,
        onRetry: () => provider.refreshWeather(),
      );
    }

    // State 3: Weather Data Loaded Successfully
    if (provider.hasData) {
      final weather = provider.weather!;

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
              // Main Weather Hero Card
              WeatherCard(
                cityName: weather.cityName,
                country: 'Weather Report',
                temperature: weather.formattedTemperature,
                condition: weather.condition,
                date: 'Today',
                icon: weather.conditionIcon, // Used WeatherModel getter directly!
              ),
              const SizedBox(height: AppSpacing.lg),

              // Extra Details Metrics Card
              ExtraInfoCard(
                humidity: weather.formattedHumidity,
                windSpeed: weather.formattedWindSpeed,
                feelsLike: weather.formattedFeelsLike,
              ),
            ],
          ),
        ),
      );
    }

    // State 4: Empty State View
    return const EmptyStateWidget(key: ValueKey('empty'));
  }
}
