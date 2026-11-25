const int minimumSupportedAgeYears = 18;

/// static estimation from Kevin Hall (2011)
/// based on Wishnofsky (1958)
const double kcalPerKgBodyWeight = 7700;

enum ActivityLevel {
  sedentary(1.2),
  lightlyActive(1.375),
  moderatelyActive(1.55),
  veryActive(1.725),
  extraActive(1.9);

  const ActivityLevel(this.factor);
  final double factor;
}

/// unspecified is the average of the 2 constants
enum BmrSex {
  male(5),
  female(-161),
  unspecified(-78);

  const BmrSex(this.offsetKcal);
  final double offsetKcal;
}

/// return calories per day
///
/// from the equation Mifflin-St Jeor, 1990
double basalMetabolicRateKcal({
  required double weightKg,
  required double heightCm,
  required int ageYears,
  required BmrSex sex,
}) {
  _checkPositive(weightKg, 'weightKg');
  _checkPositive(heightCm, 'heightCm');

  if (ageYears < minimumSupportedAgeYears) {
    throw ArgumentError.value(
      ageYears,
      'ageYears',
      'must be >= $minimumSupportedAgeYears',
    );
  }

  return 10 * weightKg + 6.25 * heightCm - 5 * ageYears + sex.offsetKcal;
}

double maintenanceEnergyKcal({
  required double bmrKcal,
  required ActivityLevel activity,
}) {
  _checkPositive(bmrKcal, 'bmrKcal');

  return bmrKcal * activity.factor;
}

/// [weeklyWeightChangeKg] if positive weight gain and if negative weight lose
double dailyEnergyTargetKcal({
  required double maintenanceKcal,
  required double weeklyWeightChangeKg,
}) {
  _checkPositive(maintenanceKcal, 'maintenanceKcal');
  if (!weeklyWeightChangeKg.isFinite) {
    throw ArgumentError.value(
      weeklyWeightChangeKg,
      'weeklyWeightChangeKg',
      'must be finite',
    );
  }

  return maintenanceKcal +
      (weeklyWeightChangeKg * kcalPerKgBodyWeight / DateTime.daysPerWeek);
}

void _checkPositive(double value, String name) {
  if (!value.isFinite || value <= 0) {
    throw ArgumentError.value(value, name, 'must be finite and > 0');
  }
}
