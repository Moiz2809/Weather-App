/// Custom Exception class for handling application and API errors cleanly.
class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return prefix != null ? '$prefix: $message' : message;
  }
}

/// Network/API fetch related exceptions
class NetworkException extends AppException {
  NetworkException(String message) : super(message, 'Network Error');
}

/// City not found exception
class CityNotFoundException extends AppException {
  CityNotFoundException(String city)
      : super('City "$city" not found. Please check spelling.', 'Not Found');
}

/// Local storage related exceptions
class StorageException extends AppException {
  StorageException(String message) : super(message, 'Storage Error');
}
