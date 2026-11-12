import 'package:flutter_test/flutter_test.dart';

import 'package:nota/domain/nutrition/nutrition_facts.dart';

NutritionFacts buildFacts({
  double energyKcal = 400,
  double energyKj = 1674,
  double proteinG = 10,
  double carbohydratesG = 50,
  double fatG = 16,
}) {
  return NutritionFacts(
    energyKcal: energyKcal,
    energyKj: energyKj,
    proteinG: proteinG,
    carbohydratesG: carbohydratesG,
    fatG: fatG,
  );
}

final fieldBuilders = <String, NutritionFacts Function(double)>{
  'energyKcal': (value) => buildFacts(energyKcal: value),
  'energyKj': (value) => buildFacts(energyKj: value),
  'proteinG': (value) => buildFacts(proteinG: value),
  'carbohydratesG': (value) => buildFacts(carbohydratesG: value),
  'fatG': (value) => buildFacts(fatG: value),
};

final invalidValues = <String, double>{
  'negative': -1,
  'infinite': double.infinity,
  'NaN': double.nan,
};

void main() {
  group('NutritionFacts', () {
    for (final field in fieldBuilders.entries) {
      group(field.key, () {
        for (final invalid in invalidValues.entries) {
          test('rejects a ${invalid.key} value', () {
            expect(() => field.value(invalid.value), throwsArgumentError);
          });
        }
        test('accepts zero', () {
          expect(() => field.value(0), returnsNormally);
        });
        test('is not equal to the base instance it differs', () {
          expect(() => field.value(999), isNot(equals(buildFacts())));
        });
      });
    }
    test('is equal to another instance with the same values', () {
      final a = buildFacts();
      final b = buildFacts();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
    test('is not equal to another instance with different values', () {
      final a = buildFacts(proteinG: 10);
      final b = buildFacts(proteinG: 5);
      expect(a, isNot(equals(b)));
      expect(a.hashCode, isNot(b.hashCode));
    });
  });
}
