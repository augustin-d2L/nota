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

  @override
  bool operator ==(Object other) =>
      other is NutritionFacts &&
      other.energyKcal == energyKcal &&
      other.energyKj == energyKj &&
      other.proteinG == proteinG &&
      other.carbohydratesG == carbohydratesG &&
      other.fatG == fatG;

  @override
  int get hashCode =>
      Object.hash(energyKcal, energyKj, proteinG, carbohydratesG, fatG);

  @override
  String toString() =>
      'NutritionFacts(energyKcal: $energyKcal, energyKj: $energyKj, '
      'proteinG: $proteinG, carbohydratesG: $carbohydratesG, fatG: $fatG)';
}
