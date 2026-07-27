/// Input validator for city names.
class CityValidator {
  /// Validates a city search query.
  /// Returns null if valid, or a friendly user error message string if invalid.
  static String? validate(String? query) {
    if (query == null || query.trim().isEmpty) {
      return 'Please enter a city name.';
    }

    final trimmed = query.trim();

    // Check 1: Minimum length requirement
    if (trimmed.length < 2) {
      return 'City name must be at least 2 characters long.';
    }

    // Check 2: Reject numbers only (e.g. "12345")
    final bool isNumbersOnly = RegExp(r'^[0-9]+$').hasMatch(trimmed);
    if (isNumbersOnly) {
      return 'City name cannot contain only numbers. Please enter a valid city name (e.g., London).';
    }

    // Check 3: Reject special characters only (e.g. "@#$%!")
    final bool isSpecialCharsOnly = RegExp(r'^[^a-zA-Z0-9]+$').hasMatch(trimmed);
    if (isSpecialCharsOnly) {
      return 'City name cannot consist only of special characters. Please enter a valid city name.';
    }

    // Check 4: Must contain at least one letter (supports international city names)
    final bool hasAtLeastOneLetter = RegExp(r'[a-zA-Z\u00C0-\u024F\u1E00-\u1EFF]').hasMatch(trimmed);
    if (!hasAtLeastOneLetter) {
      return 'City name must contain letters (e.g., New York, Paris).';
    }

    // Valid city input
    return null;
  }
}
