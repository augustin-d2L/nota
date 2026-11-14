import 'package:flutter_test/flutter_test.dart';
import 'package:nota/domain/nutrition/nutrient_amount.dart';

NutrientAmounts _amounts({
  double kcal = 0,
  double kj = 0,
  double protein = 0,
  double carbs = 0,
  double fat = 0,
}) => NutrientAmounts(
  energyKcal: kcal,
  energyKj: kj,
  proteinG: protein,
  carbohydratesG: carbs,
  fatG: fat,
);

final _fieldBuilders = <String, NutrientAmounts Function(double)>{
  'energyKcal': (value) => _amounts(kcal: value),
  'energyKj': (value) => _amounts(kj: value),
  'proteinG': (value) => _amounts(protein: value),
  'carbohydratesG': (value) => _amounts(carbs: value),
  'fatG': (value) => _amounts(fat: value),
};

const _invalidValues = <String, double>{
  'a negative': -1,
  'an infinite': double.infinity,
  'a NaN': double.nan,
};

void main() {
  group('NutritionAmounts', () {
    group('constructors', () {
      for (final field in _fieldBuilders.entries) {
        group(field.key, () {
          for (final invalid in _invalidValues.entries) {
            test('rejects a ${invalid.key} value', () {
              expect(() => field.value(invalid.value), throwsArgumentError);
            });
          }

          test('accepts zero', () {
            expect(() => field.value(0), returnsNormally);
          });
        });
      }
    });

    group('equality', () {
      for (final field in _fieldBuilders.entries) {
        test('is not equal when ${field.key} differs', () {
          expect(field.value(999), isNot(equals(_amounts())));
        });
      }

      test('is equal to another instance with the same values', () {
        final a = _amounts();
        final b = _amounts();
        expect(a, equals(b));
        expect(a.hashCode, b.hashCode);
      });
    });
  });
}
