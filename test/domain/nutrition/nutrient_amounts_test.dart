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
    group('amountFor', () {
      final NutrientAmounts a = NutrientAmounts(
        energyKcal: 400,
        energyKj: 1674,
        proteinG: 10,
        carbohydratesG: 50,
        fatG: 16,
      );
      test('scales correctly', () {
        _expectAmounts(
          a.amountFor(150),
          energyKcal: 600,
          energyKj: 2511,
          proteinG: 15,
          carbohydratesG: 75,
          fatG: 24,
        );
      });
      test('does not change for quantity = 100', () {
        _expectAmounts(
          a.amountFor(100),
          energyKcal: a.energyKcal,
          energyKj: a.energyKj,
          proteinG: a.proteinG,
          carbohydratesG: a.carbohydratesG,
          fatG: a.fatG,
        );
      });
      test('scales small quantity correctly', () {
        _expectAmounts(
          a.amountFor(2.5),
          energyKcal: a.energyKcal / 40,
          energyKj: a.energyKj / 40,
          proteinG: a.proteinG / 40,
          carbohydratesG: a.carbohydratesG / 40,
          fatG: a.fatG / 40,
        );
      });
      test('gives zero for zero quantity', () {
        expect(a.amountFor(0), NutrientAmounts.zero);
      });
      test('throw error for negative quantity', () {
        expect(() => a.amountFor(-1), throwsArgumentError);
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

        _expectAmounts(
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
