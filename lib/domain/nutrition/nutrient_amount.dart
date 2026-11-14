import 'package:nota/domain/nutrition/energy.dart';
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
