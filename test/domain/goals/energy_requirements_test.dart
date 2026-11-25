import 'package:flutter_test/flutter_test.dart';

import 'package:nota/domain/goals/energy_requirements.dart';

const double _tolerance = 1e-9;

const _invalidMeasurements = <String, double>{
  'a zero': 0,
  'a negative': -1,
  'an infinite': double.infinity,
  'a NaN': double.nan,
};

const _invalidWeeklyChanges = <String, double>{
  'an infinite': double.infinity,
  'a negative infinite': double.negativeInfinity,
  'a NaN': double.nan,
};

final _measurementBuilders = <String, double Function(double)>{
  'weightKg': (value) => _bmr(weightKg: value),
  'heightCm': (value) => _bmr(heightCm: value),
};

const _expectedBmrBySex = <BmrSex, double>{
  BmrSex.male: 1780,
  BmrSex.female: 1614,
  BmrSex.unspecified: 1697,
};

const _expectedMaintenance = <ActivityLevel, double>{
  ActivityLevel.sedentary: 2136,
  ActivityLevel.lightlyActive: 2447.5,
  ActivityLevel.moderatelyActive: 2759,
  ActivityLevel.veryActive: 3070.5,
  ActivityLevel.extraActive: 3382,
};

/// Reference profile: 80 kg, 180 cm, 30 years old, male (BMR = 1780 kcal).
double _bmr({
  double weightKg = 80,
  double heightCm = 180,
  int ageYears = 30,
  BmrSex sex = BmrSex.male,
}) => basalMetabolicRateKcal(
  weightKg: weightKg,
  heightCm: heightCm,
  ageYears: ageYears,
  sex: sex,
);

/// Matches an [ArgumentError] raised for the parameter called [name].
Matcher _throwsArgumentErrorFor(String name) =>
    throwsA(isA<ArgumentError>().having((e) => e.name, 'name', name));

void main() {
  group('basalMetabolicRateKcal', () {
    test('computes 1345.25 kcal for a 60 kg, 165 cm, 25-year-old female', () {
      expect(
        _bmr(weightKg: 60, heightCm: 165, ageYears: 25, sex: BmrSex.female),
        closeTo(1345.25, _tolerance),
      );
    });

    test('covers every sex', () {
      expect(_expectedBmrBySex.keys, unorderedEquals(BmrSex.values));
    });

    for (final MapEntry(key: sex, value: expected)
        in _expectedBmrBySex.entries) {
      test(
        'computes $expected kcal for the reference profile as ${sex.name}',
        () {
          expect(_bmr(sex: sex), closeTo(expected, _tolerance));
        },
      );
    }

    test('places unspecified halfway between male and female', () {
      final male = _bmr(sex: BmrSex.male);
      final female = _bmr(sex: BmrSex.female);

      expect(
        _bmr(sex: BmrSex.unspecified),
        closeTo((male + female) / 2, _tolerance),
      );
    });

    test('accepts the minimum supported age', () {
      expect(() => _bmr(ageYears: minimumSupportedAgeYears), returnsNormally);
    });

    test('rejects an age below the minimum supported age', () {
      expect(
        () => _bmr(ageYears: minimumSupportedAgeYears - 1),
        _throwsArgumentErrorFor('ageYears'),
      );
    });

    for (final MapEntry(key: field, value: build)
        in _measurementBuilders.entries) {
      group(field, () {
        for (final MapEntry(key: label, value: value)
            in _invalidMeasurements.entries) {
          test('rejects $label value', () {
            expect(() => build(value), _throwsArgumentErrorFor(field));
          });
        }
      });
    }
  });

  group('maintenanceEnergyKcal', () {
    test('covers every activity level', () {
      expect(_expectedMaintenance.keys, unorderedEquals(ActivityLevel.values));
    });

    for (final MapEntry(key: activity, value: expected)
        in _expectedMaintenance.entries) {
      test('multiplies BMR by ${activity.factor} for ${activity.name}', () {
        expect(
          maintenanceEnergyKcal(bmrKcal: 1780, activity: activity),
          closeTo(expected, _tolerance),
        );
      });
    }

    for (final MapEntry(key: label, value: value)
        in _invalidMeasurements.entries) {
      test('rejects $label bmrKcal', () {
        expect(
          () => maintenanceEnergyKcal(
            bmrKcal: value,
            activity: ActivityLevel.sedentary,
          ),
          _throwsArgumentErrorFor('bmrKcal'),
        );
      });
    }
  });

  group('dailyEnergyTargetKcal', () {
    test('subtracts 550 kcal per day to lose 0.5 kg per week', () {
      expect(
        dailyEnergyTargetKcal(
          maintenanceKcal: 2759,
          weeklyWeightChangeKg: -0.5,
        ),
        closeTo(2209, _tolerance),
      );
    });

    test('equals maintenance when the weekly change is zero', () {
      expect(
        dailyEnergyTargetKcal(maintenanceKcal: 2759, weeklyWeightChangeKg: 0),
        closeTo(2759, _tolerance),
      );
    });

    test('adds 275 kcal per day to gain 0.25 kg per week', () {
      expect(
        dailyEnergyTargetKcal(
          maintenanceKcal: 2759,
          weeklyWeightChangeKg: 0.25,
        ),
        closeTo(3034, _tolerance),
      );
    });

    for (final MapEntry(key: label, value: value)
        in _invalidMeasurements.entries) {
      test('rejects $label maintenanceKcal', () {
        expect(
          () => dailyEnergyTargetKcal(
            maintenanceKcal: value,
            weeklyWeightChangeKg: 0,
          ),
          _throwsArgumentErrorFor('maintenanceKcal'),
        );
      });
    }

    for (final MapEntry(key: label, value: value)
        in _invalidWeeklyChanges.entries) {
      test('rejects $label weekly weight change', () {
        expect(
          () => dailyEnergyTargetKcal(
            maintenanceKcal: 2759,
            weeklyWeightChangeKg: value,
          ),
          _throwsArgumentErrorFor('weeklyWeightChangeKg'),
        );
      });
    }

    test('chains BMR, activity and goal for the reference profile', () {
      final maintenance = maintenanceEnergyKcal(
        bmrKcal: _bmr(),
        activity: ActivityLevel.moderatelyActive,
      );

      expect(
        dailyEnergyTargetKcal(
          maintenanceKcal: maintenance,
          weeklyWeightChangeKg: -0.5,
        ),
        closeTo(2209, _tolerance),
      );
    });
  });
}
