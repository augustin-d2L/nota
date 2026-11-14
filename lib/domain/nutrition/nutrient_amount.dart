import 'package:nota/domain/nutrition/nutrient_validation.dart';

final class NutrientAmounts {
  NutrientAmounts({
    required this.energyKcal,
    required this.energyKj,
    required this.proteinG,
    required this.carbohydratesG,
    required this.fatG,
  }) {
    checkNutrientValue(energyKcal, 'energyKcal');
    checkNutrientValue(energyKj, 'energyKj');
    checkNutrientValue(proteinG, 'proteinG');
    checkNutrientValue(carbohydratesG, 'carbohydratesG');
    checkNutrientValue(fatG, 'fatG');
  }

  static final zero = NutrientAmounts(
    energyKcal: 0,
    energyKj: 0,
    proteinG: 0,
    carbohydratesG: 0,
    fatG: 0,
  );

  final double energyKcal;
  final double energyKj;
  final double proteinG;
  final double carbohydratesG;
  final double fatG;

  /// Returns the nutrients contained in [quantity] of this food,
  /// expressed in the food's reference unit (g or ml).
  NutrientAmounts amountFor(double quantity) {
    checkNutrientValue(quantity, 'quantity');
    return NutrientAmounts(
      energyKcal: energyKcal * (quantity / 100),
      energyKj: energyKj * (quantity / 100),
      proteinG: proteinG * (quantity / 100),
      carbohydratesG: carbohydratesG * (quantity / 100),
      fatG: fatG * (quantity / 100),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is NutrientAmounts &&
      other.energyKcal == energyKcal &&
      other.energyKj == energyKj &&
      other.proteinG == proteinG &&
      other.carbohydratesG == carbohydratesG &&
      other.fatG == fatG;

  NutrientAmounts operator +(NutrientAmounts other) => NutrientAmounts(
    energyKcal: energyKcal + other.energyKcal,
    energyKj: energyKj + other.energyKj,
    proteinG: proteinG + other.proteinG,
    carbohydratesG: carbohydratesG + other.carbohydratesG,
    fatG: fatG + other.fatG,
  );

  @override
  int get hashCode =>
      Object.hash(energyKcal, energyKj, proteinG, carbohydratesG, fatG);

  @override
  String toString() =>
      'NutrientAmounts(energyKcal: $energyKcal, energyKj: $energyKj, '
      'proteinG: $proteinG, carbohydratesG: $carbohydratesG, fatG: $fatG)';
}

extension NutrientAmountsSum on Iterable<NutrientAmounts> {
  NutrientAmounts sum() =>
      fold(NutrientAmounts.zero, (total, item) => total + item);
}
