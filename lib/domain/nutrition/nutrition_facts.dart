final class NutritionFacts {
  NutritionFacts({
    required this.energyKcal,
    required this.energyKj,
    required this.proteinG,
    required this.carbohydratesG,
    required this.fatG,
  }) {
    _checkAmount(energyKcal, 'energyKcal');
    _checkAmount(energyKj, 'energyKj');
    _checkAmount(proteinG, 'proteinG');
    _checkAmount(carbohydratesG, 'carbohydratesG');
    _checkAmount(fatG, 'fatG');
  }

  final double energyKcal;
  final double energyKj;
  final double proteinG;
  final double carbohydratesG;
  final double fatG;

  static void _checkAmount(double value, String name) {
    if (!value.isFinite || value < 0) {
      throw ArgumentError.value(value, name, 'must be finite and >= 0');
    }
  }
}
