# 🌦️ Weather App

A modern and responsive Flutter Weather App that provides real-time weather information using API integration. The application follows a clean architecture with Provider state management, reusable widgets, responsive UI, proper validation, and robust error handling.

---

## 📱 Features

- 🌍 Search weather by city name
- 🌡️ Real-time weather information
- ☁️ Weather condition with icons
- 💨 Wind speed
- 💧 Humidity
- 🌡️ Feels Like temperature
- 🔍 Input validation
- ⚠️ Error handling for invalid city and network issues
- 📱 Responsive UI
- 🎨 Material 3 Design
- 🧩 Reusable widgets
- 🏗️ Clean project architecture
- 🌙 Dark Mode support
- 🌡️ Celsius / Fahrenheit temperature toggle
- 📅 7-Day Weather Forecast
- 🗺️ Current Location Weather (GPS)
- 📊 Hourly Temperature Graph
- 💾 Local storage using SharedPreferences

---

## 🚀 Technologies Used

- Flutter
- Dart
- Provider (State Management)
- HTTP Package
- SharedPreferences
- Geolocator
- FL Chart
- OpenWeatherMap API
- Open-Meteo API

---

## 📂 Project Structure

```text
lib/
│
├── core/
│   ├── constants/
│   ├── exceptions/
│   └── theme/
│
├── models/
│
├── providers/
│
├── services/
│
├── screens/
│
├── widgets/
│
├── utils/
│
└── main.dart
```

---

## 📡 API Integration

The application fetches weather information using:

- OpenWeatherMap API (Current Weather)
- Open-Meteo API (Forecast & Backup Weather Service)

---

## ✨ Future Improvements

- Air Quality Index (AQI)
- Weather Alerts
- Favorite Cities
- Weather History
- Multi-language Support
- Animated Weather Icons
- Offline Weather Cache

---

## ▶️ Getting Started

### Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/weather_app.git
```

### Navigate to the project

```bash
cd weather_app
```

### Install dependencies

```bash
flutter pub get
```

### Run the application

```bash
flutter run
```

---

## 📦 Dependencies

```yaml
provider
http
shared_preferences
geolocator
fl_chart
```

---

## 👨‍💻 Author

**Muhammad Moiz Ur Rehman**

GitHub: https://github.com/Moiz2809

---

## 📄 License

This project is developed for learning and internship purposes.