import 'package:nota/domain/nutrition/energy.dart';
import 'package:nota/domain/nutrition/nutrient_amounts.dart';
import 'package:nota/domain/nutrition/nutrient_validation.dart';

final class NutritionFacts {
  NutritionFacts({
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

  /// Builds facts from a nutrition label.
  ///
  /// [per] is the label's reference amount: 100 for "per 100 g", 30 for "per 30 g serving".
  factory NutritionFacts.fromLabel({
    required double per,
    double? energyKcal,
    double? energyKj,
    required double proteinG,
    required double carbohydratesG,
    required double fatG,
  }) {
    checkNutrientValue(per, 'per');
    if (per == 0) {
      throw ArgumentError.value(per, 'per', 'must be > 0');
    }

    final (kcal, kj) = switch ((energyKcal, energyKj)) {
      (final c?, final j?) => (c, j),
      (final c?, null) => (c, kcalToKj(c)),
      (null, final j?) => (kjToKcal(j), j),
      (null, null) => throw ArgumentError('energyKcal or energyKj is required'),
    };

    final factor = 100 / per;

    return NutritionFacts(
      energyKcal: kcal * factor,
      energyKj: kj * factor,
      proteinG: proteinG * factor,
      carbohydratesG: carbohydratesG * factor,
      fatG: fatG * factor,
    );
  }

  final double energyKcal;
  final double energyKj;
  final double proteinG;
  final double carbohydratesG;
  final double fatG;

  /// Returns the nutrients contained in [quantity] of this food,
  /// expressed in the food's reference unit (g or ml).
  NutrientAmounts amountFor(double quantity) {
    checkNutrientValue(quantity, 'quantity');
    final factor = quantity / 100;
    return NutrientAmounts(
      energyKcal: energyKcal * factor,
      energyKj: energyKj * factor,
      proteinG: proteinG * factor,
      carbohydratesG: carbohydratesG * factor,
      fatG: fatG * factor,
    );
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
