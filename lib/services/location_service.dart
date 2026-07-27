import 'package:geolocator/geolocator.dart';
import '../core/app_exception.dart';

/// Service responsible for managing device location permissions and fetching current GPS coordinates.
class LocationService {
  /// Fetches the user's current latitude and longitude position safely.
  /// Handles permission requests, permission denials, and disabled GPS services.
  Future<Position> getCurrentLocation() async {
    // 1. Check if device location services (GPS) are turned on
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw NetworkException(
        'Location services (GPS) are disabled. Please turn on GPS in your device settings.',
      );
    }

    // 2. Check current location permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // 3. Request permission if currently denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw NetworkException(
          'Location permission was denied. Please grant location access to view local weather.',
        );
      }
    }

    // 4. Handle permanently denied permissions (User selected "Don't ask again")
    if (permission == LocationPermission.deniedForever) {
      throw NetworkException(
        'Location permissions are permanently denied. Please enable location access in app settings.',
      );
    }

    // 5. Permission granted: Fetch current device position with medium accuracy
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      ),
    );
  }
}
