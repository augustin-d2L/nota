import 'package:flutter_test/flutter_test.dart';
import 'package:nota/domain/nutrition/nutrient_amount.dart';

import 'nutrient_matchers.dart';

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
  group('NutrientAmounts', () {
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
    group('addition', () {
      test('adds each fields', () {
        final NutrientAmounts a = _amounts(
          kcal: 10,
          kj: 10,
          protein: 10,
          carbs: 10,
          fat: 10,
        );
        final NutrientAmounts b = _amounts(
          kcal: 10,
          kj: 10,
          protein: 10,
          carbs: 10,
          fat: 10,
        );
        expectAmounts(
          a + b,
          energyKcal: a.energyKcal + b.energyKcal,
          energyKj: a.energyKj + b.energyKj,
          proteinG: a.proteinG + b.proteinG,
          carbohydratesG: a.carbohydratesG + b.carbohydratesG,
          fatG: a.fatG + b.fatG,
        );
      });
      test('does not move with 0', () {
        final NutrientAmounts a = _amounts(
          kcal: 10,
          kj: 10,
          protein: 10,
          carbs: 10,
          fat: 10,
        );
        final NutrientAmounts b = _amounts();
        expectAmounts(
          a + b,
          energyKcal: a.energyKcal,
          energyKj: a.energyKj,
          proteinG: a.proteinG,
          carbohydratesG: a.carbohydratesG,
          fatG: a.fatG,
        );
      });
    });

    group('on Iterable', () {
      test('returns zero for an empty list', () {
        expect(<NutrientAmounts>[].sum(), NutrientAmounts.zero);
      });
      test('adds every element field by field', () {
        final items = [
          _amounts(kcal: 100, kj: 418, protein: 1, carbs: 2, fat: 3),
          _amounts(kcal: 200, kj: 837, protein: 4, carbs: 5, fat: 6),
          _amounts(kcal: 50, kj: 209, protein: 7, carbs: 8, fat: 9),
        ];

        expectAmounts(
          items.sum(),
          energyKcal: 350,
          energyKj: 1464,
          proteinG: 12,
          carbohydratesG: 15,
          fatG: 18,
        );
      });
    });
  });
}
