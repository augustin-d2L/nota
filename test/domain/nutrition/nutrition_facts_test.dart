import 'package:flutter_test/flutter_test.dart';

import 'package:nota/domain/nutrition/nutrition_facts.dart';

const _tolerance = 1e-9;

NutritionFacts _buildFacts({
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

void _expectFacts(
  NutritionFacts facts, {
  required double energyKcal,
  required double energyKj,
  required double proteinG,
  required double carbohydratesG,
  required double fatG,
}) {
  expect(
    facts.energyKcal,
    closeTo(energyKcal, _tolerance),
    reason: 'energyKcal',
  );
  expect(facts.energyKj, closeTo(energyKj, _tolerance), reason: 'energyKj');
  expect(facts.proteinG, closeTo(proteinG, _tolerance), reason: 'proteinG');
  expect(
    facts.carbohydratesG,
    closeTo(carbohydratesG, _tolerance),
    reason: 'carbohydratesG',
  );
  expect(facts.fatG, closeTo(fatG, _tolerance), reason: 'fatG');
}

final _fieldBuilders = <String, NutritionFacts Function(double)>{
  'energyKcal': (value) => _buildFacts(energyKcal: value),
  'energyKj': (value) => _buildFacts(energyKj: value),
  'proteinG': (value) => _buildFacts(proteinG: value),
  'carbohydratesG': (value) => _buildFacts(carbohydratesG: value),
  'fatG': (value) => _buildFacts(fatG: value),
};

const _invalidValues = <String, double>{
  'a negative': -1,
  'an infinite': double.infinity,
  'a NaN': double.nan,
};

const _invalidPers = <String, double>{..._invalidValues, 'a zero': 0};

void main() {
  group('NutritionFacts', () {
    group('constructor', () {
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
          expect(field.value(999), isNot(equals(_buildFacts())));
        });
      }

      test('is equal to another instance with the same values', () {
        final a = _buildFacts();
        final b = _buildFacts();
        expect(a, equals(b));
        expect(a.hashCode, b.hashCode);
      });
    });

    group('fromLabel', () {
      test('scales every value from a 25 g serving to 100 g', () {
        final facts = NutritionFacts.fromLabel(
          per: 25,
          energyKcal: 100,
          energyKj: 420,
          proteinG: 2.5,
          carbohydratesG: 12.5,
          fatG: 4,
        );
        _expectFacts(
          facts,
          energyKcal: 400,
          energyKj: 1680,
          proteinG: 10,
          carbohydratesG: 50,
          fatG: 16,
        );
      });

      test('scales a 30 g serving without rounding', () {
        final facts = NutritionFacts.fromLabel(
          per: 30,
          energyKcal: 120,
          proteinG: 3,
          carbohydratesG: 15,
          fatG: 5,
        );
        _expectFacts(
          facts,
          energyKcal: 400,
          energyKj: 400 * 4.184,
          proteinG: 10,
          carbohydratesG: 50,
          fatG: 500 / 30,
        );
      });

      test('keeps both energy values exactly as given on the label', () {
        final facts = NutritionFacts.fromLabel(
          per: 100,
          proteinG: 10,
          carbohydratesG: 10,
          fatG: 10,
          energyKcal: 250,
          energyKj: 1050,
        );
        _expectFacts(
          facts,
          energyKcal: 250,
          energyKj: 1050,
          proteinG: 10,
          carbohydratesG: 10,
          fatG: 10,
        );
      });

      test('derives energyKj from energyKcal when only kcal is given', () {
        final facts = NutritionFacts.fromLabel(
          per: 100,
          proteinG: 10,
          carbohydratesG: 10,
          fatG: 10,
          energyKcal: 400,
        );
        _expectFacts(
          facts,
          energyKcal: 400,
          energyKj: 1673.6,
          proteinG: 10,
          carbohydratesG: 10,
          fatG: 10,
        );
      });

      test('derives energyKcal from energyKj when only kJ is given', () {
        final facts = NutritionFacts.fromLabel(
          per: 100,
          proteinG: 10,
          carbohydratesG: 10,
          fatG: 10,
          energyKj: 1673.6,
        );
        _expectFacts(
          facts,
          energyKcal: 400,
          energyKj: 1673.6,
          proteinG: 10,
          carbohydratesG: 10,
          fatG: 10,
        );
      });

      test('throws when neither energy value is given', () {
        expect(
          () => NutritionFacts.fromLabel(
            per: 100,
            proteinG: 10,
            carbohydratesG: 10,
            fatG: 10,
          ),
          throwsArgumentError,
        );
      });

      group('per', () {
        for (final invalid in _invalidPers.entries) {
          test('rejects ${invalid.key} value', () {
            expect(
              () => NutritionFacts.fromLabel(
                per: invalid.value,
                proteinG: 10,
                carbohydratesG: 10,
                fatG: 10,
                energyKcal: 500,
              ),
              throwsArgumentError,
            );
          });
        }
      });
    });
  });
}
