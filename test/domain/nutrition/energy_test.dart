import 'package:flutter_test/flutter_test.dart';

import 'package:nota/domain/nutrition/energy.dart';

void main() {
  group('kcalToKj', () {
    test('converts 100 kcal to 418.4 kJ', () {
      expect(kcalToKj(100), closeTo(418.4, 1e-9));
    });
  });

  group('kjToKcal', () {
    test('converts 418.4 kj to 100 kcal', () {
      expect(kjToKcal(418.4), closeTo(100, 1e-9));
    });
  });

  group('0kcalto0kj', () {
    test('0 kcal is 0 kj', () {
      expect(kcalToKj(0), 0);
    });
  });

  group('comeAndGo', () {
    test('100 kcal to kj to kcal is 100', () {
      expect(kjToKcal(kcalToKj(100)), closeTo(100, 1e-9));
    });
  });
}
