import 'package:flutter_test/flutter_test.dart';
import 'package:nota/domain/nutrition/nutrient_amount.dart';

const _tolerance = 1e-9;

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

void _expectAmounts(
  NutrientAmounts amounts, {
  required double energyKcal,
  required double energyKj,
  required double proteinG,
  required double carbohydratesG,
  required double fatG,
}) {
  expect(
    amounts.energyKcal,
    closeTo(energyKcal, _tolerance),
    reason: 'energyKcal',
  );
  expect(amounts.energyKj, closeTo(energyKj, _tolerance), reason: 'energyKj');
  expect(amounts.proteinG, closeTo(proteinG, _tolerance), reason: 'proteinG');
  expect(
    amounts.carbohydratesG,
    closeTo(carbohydratesG, _tolerance),
    reason: 'carbohydratesG',
  );
  expect(amounts.fatG, closeTo(fatG, _tolerance), reason: 'fatG');
}

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
        _expectAmounts(
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
        _expectAmounts(
          a + b,
          energyKcal: a.energyKcal,
          energyKj: a.energyKj,
          proteinG: a.proteinG,
          carbohydratesG: a.carbohydratesG,
          fatG: a.fatG,
        );
      });
    });
  });
}
