/// Resilient parsing utilities for handling API responses with inconsistent types.
class SafeParser {
  SafeParser._();

  /// Safely parse a nullable numeric value into a [double].
  /// Handles `num`, `int`, `double`, `String`, and fallback defaults.
  static double toDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  /// Safely parse a nullable numeric value into a nullable [double].
  static double? toDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  /// Safely parse a nullable numeric value into an [int].
  static int toInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) {
      final parsedInt = int.tryParse(value.trim());
      if (parsedInt != null) return parsedInt;
      final parsedDouble = double.tryParse(value.trim());
      return parsedDouble?.toInt() ?? defaultValue;
    }
    return defaultValue;
  }

  /// Safely parse a nullable numeric value into a nullable [int].
  static int? toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) {
      final parsedInt = int.tryParse(value.trim());
      if (parsedInt != null) return parsedInt;
      return double.tryParse(value.trim())?.toInt();
    }
    return null;
  }

  /// Safely parse a value into a [String].
  static String toStringVal(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  /// Safely parse a value into a [bool].
  static bool toBool(dynamic value, [bool defaultValue = false]) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final lower = value.trim().toLowerCase();
      if (lower == 'true' || lower == '1' || lower == 'yes') return true;
      if (lower == 'false' || lower == '0' || lower == 'no') return false;
    }
    return defaultValue;
  }

  /// Safely parse a list from dynamic data.
  static List<T> toList<T>(dynamic value, T Function(dynamic item) mapper) {
    if (value == null || value is! List) return <T>[];
    return value.map((e) => mapper(e)).toList();
  }
}
