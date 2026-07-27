# ☀️ SkyWatch Weather App

A modern, responsive, and feature-complete Weather Application built with **Flutter**, **Material 3**, and **Provider** for state management. The app delivers real-time weather forecasts, air quality index monitoring, severe weather advisories, 24-hour temperature trend charts, GPS location detection, favorite cities management, recent search history, dark mode, and vector-animated weather icons across mobile and tablet devices.

---

## 🚀 Features

- 🌤️ **Real-Time Weather Data**: Displays current temperature, weather condition text, humidity, wind speed, and "Feels Like" temperature.
- 💨 **Air Quality Index (AQI)**: Monitors AQI severity levels (1–5: Good, Fair, Moderate, Poor, Very Poor) and 5 pollutant concentrations (PM2.5, PM10, CO, NO₂, O₃).
- ⚠️ **Severe Weather Alerts**: High-visibility weather advisory banners displaying warning titles, descriptions, severity badges, and active time windows (auto-hides when no alerts exist).
- 📊 **24-Hour Hourly Temperature Chart**: Smooth interactive line chart built with `fl_chart`, displaying 24-hour temperature trends labeled with time and temperature axes.
- 📍 **GPS Current Location Support**: Single-tap GPS coordinate acquisition via `geolocator` with automatic location permission handling.
- ❤️ **Favorite Cities Management**: Dedicated `FavoritesScreen` allowing users to bookmark, view, tap-to-load, and remove favorite cities.
- 🕒 **Search History Chips**: Tracks up to 10 recent city searches with automatic deduplication, one-tap re-querying, and a "Clear All" action.
- 🌡️ **Celsius / Fahrenheit Toggle**: Instant temperature unit switching (°C / °F) with zero additional network API overhead.
- 🌙 **Dark Mode & Material 3**: Seamless toggle between Light and Dark themes with persistent preference storage via `SharedPreferences`.
- 🎨 **Animated Weather Icons**: Smooth vector-animated weather icons for Sunny, Cloudy, Rain, Snow, Thunderstorm, Fog, and Default conditions.
- 📱 **Fully Responsive UI**: Adapts layout padding, font scaling, and max-width containers across Android phones, phablets, and tablets.
- 🔍 **Smart Input Validation**: Prevents invalid searches by blocking empty strings, numbers-only, and special characters with friendly error messages.
- 🌐 **Multi-Language & Unicode City Search**: Full UTF-8 support for searching international cities in native alphabets.

---

## 🛠️ Technologies & Packages Used

| Package | Version | Purpose |
| :--- | :--- | :--- |
| **Flutter SDK** | `^3.12.0` | Core cross-platform UI framework |
| [`provider`](https://pub.dev/packages/provider) | `^6.1.2` | Clean reactive state management using `ChangeNotifier` |
| [`http`](https://pub.dev/packages/http) | `^1.2.1` | Asynchronous REST API network client |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | `^2.2.3` | Persistent local key-value storage on device disk |
| [`geolocator`](https://pub.dev/packages/geolocator) | `^14.0.2` | Device GPS coordinate acquisition & location permissions |
| [`fl_chart`](https://pub.dev/packages/fl_chart) | `^1.1.1` | High-performance interactive line chart rendering |
| `cupertino_icons` | `^1.0.8` | Standard iOS style iconography |

---

## 📁 Project Structure

```text
lib/
├── core/
│   └── app_exception.dart       # Custom exception classes (NetworkException, CityNotFoundException)
├── models/
│   ├── weather_model.dart       # Weather data class with JSON parsing, unit getters & coordinates
│   ├── hourly_forecast_model.dart # 24-hour forecast data point model
│   ├── aqi_model.dart           # Air Quality Index & pollutant model (PM2.5, PM10, CO, NO2, O3)
│   └── weather_alert_model.dart # Severe weather alert notification model
├── providers/
│   ├── weather_provider.dart    # Main weather, GPS & AQI state management
│   ├── theme_provider.dart      # Material 3 Light/Dark mode state management
│   ├── favorites_provider.dart  # Favorite cities state management
│   └── history_provider.dart    # Recent search history state management (max 10 items)
├── services/
│   ├── weather_service.dart     # HTTP REST client for Weather & Hourly APIs
│   ├── aqi_service.dart         # HTTP REST client for Air Quality Index APIs
│   ├── location_service.dart    # Geolocator GPS permission & coordinate acquisition
│   └── storage_service.dart     # SharedPreferences persistent disk storage service
├── screens/
│   ├── splash_screen.dart       # Branded launch screen
│   ├── home_screen.dart         # Responsive weather dashboard screen
│   └── favorites_screen.dart    # Dedicated saved favorite cities screen
├── widgets/
│   ├── weather_card.dart        # Hero weather card with dynamic condition gradients & unit toggle
│   ├── animated_weather_icon.dart # Custom vector-animated weather icons (Sunny, Rain, Snow, etc.)
│   ├── aqi_card.dart            # Air Quality Index card with 5 pollutant concentration tiles
│   ├── hourly_chart_widget.dart # Smooth 24-hour temperature line chart (fl_chart)
│   ├── alert_card.dart          # Severe weather alerts banner (auto-hiding)
│   ├── history_chips_widget.dart# Recent search history horizontal chips
│   ├── extra_info_card.dart     # Detailed metrics card container (Humidity, Wind, Feels Like)
│   ├── weather_detail_tile.dart # Reusable metric tile component
│   ├── search_bar_widget.dart   # Search bar widget with input validation
│   ├── search_textfield.dart    # Reusable styled text field input
│   ├── primary_button.dart      # Custom action button supporting icons and spinners
│   ├── loading_widget.dart      # Centered progress indicator
│   ├── error_widget.dart        # Contextual error display with retry button
│   └── empty_state_widget.dart  # Empty state illustration widget
└── utils/
    ├── colors.dart              # AppColors palette definition (Light & Dark)
    ├── constants.dart           # Global app constants, API endpoints, storage keys
    ├── responsive.dart          # Screen width breakpoint helpers for Mobile & Tablet
    ├── theme.dart               # Material 3 Light & Dark theme definitions
    └── validator.dart           # Input validation rules for city queries
```

---

## ⚙️ Installation & API Setup Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- Dart SDK `^3.12.0`
- Android Studio / VS Code

### 1. Clone & Dependencies
```bash
git clone https://github.com/Moiz2809/Weather-App.git
cd weather_app
flutter pub get
```

### 2. Configure API Key (Optional)
The project is configured out-of-the-box with a **zero-configuration fallback** to the free Open-Meteo REST API. If you wish to use your own OpenWeatherMap key:

1. Obtain a free key from [OpenWeatherMap](https://openweathermap.org/api).
2. Open `lib/utils/constants.dart`:
   ```dart
   class AppConstants {
     static const String openWeatherApiKey = 'YOUR_OPENWEATHERMAP_API_KEY_HERE';
   }
   ```

### 3. Android Location Permissions
Permissions are pre-configured in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 4. Run the Project
```bash
flutter run
```

### 5. Verify Code Health
```bash
flutter analyze
```

---

## 📡 API Architecture & Fallback Flow

```
                      ┌─────────────────────────┐
                      │ User City or GPS Search │
                      └────────────┬────────────┘
                                   │
                                   ▼
                   ┌───────────────────────────────┐
                   │  OpenWeatherMap REST API      │
                   └───────────────┬───────────────┘
                                   │
                     Status 200    │    Status 401 / Exception
               ┌───────────────────┴───────────────────┐
               ▼                                       ▼
    ┌────────────────────┐                 ┌───────────────────────┐
    │ Parse Weather Data │                 │ Open-Meteo Fallback   │
    │  & AQI Payload     │                 │   (No Key Required)   │
    └────────────────────┘                 └───────────────────────┘
```

1. **Primary Route**: Requests OpenWeatherMap endpoints for Weather, Air Pollution, and Alerts.
2. **Fallback Route**: If default API keys are used, requests route automatically to **Open-Meteo Geocoding, Forecast & Air Quality APIs**, guaranteeing immediate functionality without setup friction.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.