import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

void main() {
  runApp(
    // Wrap app with MultiProvider to register WeatherProvider, ThemeProvider, FavoritesProvider, and HistoryProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..loadThemePreference(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..loadFavorites(),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider()..loadHistory(),
        ),
      ],
      child: const WeatherApp(),
    ),
  );
}

/// Root widget of the Weather Application.
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
