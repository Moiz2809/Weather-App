# ☀️ SkyWatch Weather App

A modern, responsive, and beginner-friendly Weather Application built with **Flutter**, **Material 3**, and **Provider** for state management. The app delivers real-time weather forecasts, automatic location persistence, input validation, and adaptive layouts across mobile and tablet devices.

---

## 🚀 Features

- 🌤️ **Real-Time Weather Data**: Displays current temperature, weather conditions, humidity, wind speed, and "Feels Like" temperature.
- 📱 **Fully Responsive UI**: Adapts seamlessly to Android phones, large phones, and tablets with fluid scaling.
- 🔍 **Smart City Search**: Instant search bar with real-time input validation (blocks empty queries, numbers-only, or special characters).
- 💾 **Local Data Persistence**: Automatically saves and loads your last searched city across app restarts using `SharedPreferences`.
- 🎨 **Material 3 & Modern Design**: Dynamic weather condition-based background gradients, glassmorphism, rounded cards, and ambient drop shadows.
- ✨ **Smooth Animations**: Animated transitions between Loading, Weather Data, Error, and Empty states using `AnimatedSwitcher`.
- ⚠️ **Tailored UX Error Handling**: Contextual feedback screens for *No Internet*, *Server Error*, *City Not Found*, and *API Error* with a single-tap **Try Again** action.
- 🔄 **Pull-to-Refresh**: Seamless gesture to fetch updated weather data.

---

## 📁 Folder Structure

The project follows a clean, modular architecture designed for high readability and maintainability:

```text
lib/
├── core/
│   └── app_exception.dart       # Custom exception classes (NetworkException, CityNotFoundException)
├── models/
│   └── weather_model.dart       # Weather data class with JSON serialization & condition getters
├── providers/
│   └── weather_provider.dart    # ChangeNotifier state management (Loading, Error, Weather state)
├── services/
│   ├── weather_service.dart     # HTTP API network service & OpenWeatherMap/Open-Meteo fallback
│   └── storage_service.dart     # SharedPreferences local storage service
├── screens/
│   ├── splash_screen.dart       # Initial branded splash screen with smooth transition
│   └── home_screen.dart         # Main responsive weather dashboard page
├── widgets/
│   ├── weather_card.dart        # Hero weather card with dynamic condition gradients
│   ├── extra_info_card.dart     # Detailed metrics card container (Humidity, Wind, Feels Like)
│   ├── weather_detail_tile.dart # Reusable metric tile component
│   ├── search_bar_widget.dart   # Search bar widget with validation logic
│   ├── search_textfield.dart    # Reusable styled text input field
│   ├── primary_button.dart      # Custom action button supporting icons and loading spinners
│   ├── loading_widget.dart      # Centered progress indicator with custom status message
│   ├── error_widget.dart        # Contextual error display widget with retry button
│   └── empty_state_widget.dart  # Empty state illustration widget
└── utils/
    ├── colors.dart              # AppColors palette definition
    ├── constants.dart           # Global app constants, API URLs, and storage keys
    ├── responsive.dart          # Screen width breakpoint helpers for Mobile & Tablet
    ├── theme.dart               # Material 3 light theme definition & AppSpacing scale
    └── validator.dart           # Input validation rules for city queries
```

---

## 📦 Dependencies

The app strictly relies on stable, official Flutter packages:

| Package | Version | Purpose |
| :--- | :--- | :--- |
| [`provider`](https://pub.dev/packages/provider) | `^6.1.2` | Simple and clean state management using `ChangeNotifier`. |
| [`http`](https://pub.dev/packages/http) | `^1.2.1` | Network HTTP client for fetching REST API data. |
| [`shared_preferences`](https://pub.dev/packages/shared_preferences) | `^2.2.3` | Persistent local key-value storage on device disk. |
| `cupertino_icons` | `^1.0.8` | Standard iOS style icon asset set. |

---

## ⚙️ Installation & Setup Steps

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- Dart SDK `^3.12.0`
- Android Studio / VS Code with Flutter extension installed
- An active Internet connection

### Running the Project

1. **Clone or navigate to project directory**:
   ```bash
   cd weather_app
   ```

2. **Install Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **(Optional) Configure OpenWeatherMap API Key**:
   Open `lib/utils/constants.dart` and insert your OpenWeatherMap API key:
   ```dart
   static const String openWeatherApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
   ```
   *Note: If no API key is provided, the app automatically falls back to Open-Meteo free API for instant live weather fetching!*

4. **Run the Application**:
   ```bash
   flutter run
   ```

5. **Run Code Analysis**:
   ```bash
   flutter analyze
   ```

---

## 📡 How the API Works

1. **Request Construction**:
   When a search is submitted, `WeatherService.getWeather(city)` encodes the city query parameter and sends an HTTP `GET` request to OpenWeatherMap endpoint:
   ```text
   GET https://api.openweathermap.org/data/2.5/weather?q={city}&units=metric&appid={apiKey}
   ```

2. **Timeout Guard**:
   Requests enforce a `10-second` timeout duration using `.timeout(const Duration(seconds: 10))`.

3. **Status Code Mapping & Exception Handling**:
   - `200 OK`: JSON response is parsed into `WeatherModel.fromJson()`.
   - `404 / 400`: Throws `CityNotFoundException("City not found")`.
   - `500 / 502 / 503`: Throws `NetworkException("Server error")`.
   - `SocketException`: Caught and thrown as `NetworkException("No Internet Connection")`.

4. **Zero-Configuration Fallback**:
   If the default OpenWeatherMap API key is unconfigured, `WeatherService` gracefully routes to the **Open-Meteo Geocoding & Forecast REST API**, fetching coordinates and live weather metrics with zero setup required.

---

## 📸 Screenshots Section

| Splash Screen | Home Dashboard | Search & Validation | Error Handling |
| :---: | :---: | :---: | :---: |
| *(App Branding)* | *(Dynamic Gradients)* | *(Input Feedback)* | *(Contextual Errors)* |

---

## 🔮 Future Improvements

- 📅 **7-Day Weather Forecast**: Expand models and UI to show daily forecast cards.
- 🗺️ **GPS Location Detection**: Auto-detect current device location using `geolocator`.
- 🌙 **Dark Mode Toggle**: Manual theme toggle switch for dark mode preference.
- 🌡️ **Celsius / Fahrenheit Toggle**: Switch temperature units on the fly.
- 📊 **Hourly Temperature Graphs**: Render interactive temperature curves using charts.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
