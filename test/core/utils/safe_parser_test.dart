import 'package:flutter_test/flutter_test.dart';
import 'package:base_flutter_ai/core/utils/safe_parser.dart';

void main() {
  group('SafeParser Tests', () {
    test('toDouble parses numbers, strings and fallbacks properly', () {
      expect(SafeParser.toDouble(12.5), 12.5);
      expect(SafeParser.toDouble(12), 12.0);
      expect(SafeParser.toDouble('12.5'), 12.5);
      expect(SafeParser.toDouble('  15.75  '), 15.75);
      expect(SafeParser.toDouble(null, 1.0), 1.0);
      expect(SafeParser.toDouble('invalid_number', 5.5), 5.5);
      expect(SafeParser.toDouble([1, 2], 0.0), 0.0);
    });

    test('toDoubleOrNull returns double or null for invalid data', () {
      expect(SafeParser.toDoubleOrNull(12.5), 12.5);
      expect(SafeParser.toDoubleOrNull('12.5'), 12.5);
      expect(SafeParser.toDoubleOrNull(null), isNull);
      expect(SafeParser.toDoubleOrNull('not-a-number'), isNull);
    });

    test('toInt parses numbers, strings and fallbacks properly', () {
      expect(SafeParser.toInt(42), 42);
      expect(SafeParser.toInt(42.9), 42);
      expect(SafeParser.toInt('42'), 42);
      expect(SafeParser.toInt('42.8'), 42);
      expect(SafeParser.toInt(null, 99), 99);
      expect(SafeParser.toInt('invalid', 10), 10);
    });

    test('toIntOrNull returns int or null for invalid data', () {
      expect(SafeParser.toIntOrNull(42), 42);
      expect(SafeParser.toIntOrNull('42'), 42);
      expect(SafeParser.toIntOrNull(null), isNull);
      expect(SafeParser.toIntOrNull('invalid'), isNull);
    });

    test('toBool parses booleans, numbers, and strings properly', () {
      expect(SafeParser.toBool(true), isTrue);
      expect(SafeParser.toBool(false), isFalse);
      expect(SafeParser.toBool(1), isTrue);
      expect(SafeParser.toBool(0), isFalse);
      expect(SafeParser.toBool('true'), isTrue);
      expect(SafeParser.toBool('TRUE'), isTrue);
      expect(SafeParser.toBool('1'), isTrue);
      expect(SafeParser.toBool('false'), isFalse);
      expect(SafeParser.toBool('0'), isFalse);
      expect(SafeParser.toBool(null, true), isTrue);
      expect(SafeParser.toBool('random', false), isFalse);
    });

    test('toStringVal converts any value to string with fallback', () {
      expect(SafeParser.toStringVal('hello'), 'hello');
      expect(SafeParser.toStringVal(123), '123');
      expect(SafeParser.toStringVal(null, 'default'), 'default');
    });

    test('toList maps list items safely', () {
      final input = [1, 2, 3];
      final result = SafeParser.toList<String>(input, (item) => 'Item $item');
      expect(result, ['Item 1', 'Item 2', 'Item 3']);

      expect(SafeParser.toList<String>(null, (e) => e.toString()), isEmpty);
      expect(
        SafeParser.toList<String>('not-a-list', (e) => e.toString()),
        isEmpty,
      );
    });
  });
}
