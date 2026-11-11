final class NutritionFacts {
  double energyKcal;
  double energyKj;
  double proteinG;
  double carbohydratesG;
  double fatG;

  NutritionFacts({
    required this.energyKcal,
    required this.energyKj,
    required this.proteinG,
    required this.carbohydratesG,
    required this.fatG,
  }) {
    _checkAmount(proteinG, 'proteinG');
  }

  static void _checkAmount(double value, String name) {
    if (value < 0) {
      throw ArgumentError.value(value, name, 'must be finite and >= 0');
    }
  }
}
