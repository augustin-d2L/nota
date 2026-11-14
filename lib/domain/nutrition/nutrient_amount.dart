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

  /// Builds facts from a nutrition label.
  ///
  /// [per] is the label's reference amount: 100 for "per 100 g", 30 for "per 30 g serving".
  factory NutrientAmounts.fromLabel({
    required double per,
    double? energyKcal,
    double? energyKj,
    required double proteinG,
    required double carbohydratesG,
    required double fatG,
  }) {
    if (!per.isFinite || per <= 0) {
      throw ArgumentError.value(per, 'per', 'must be finite and > 0');
    }

    final (kcal, kj) = switch ((energyKcal, energyKj)) {
      (final c?, final j?) => (c, j),
      (final c?, null) => (c, kcalToKj(c)),
      (null, final j?) => (kjToKcal(j), j),
      (null, null) => throw ArgumentError('energyKcal or energyKj is required'),
    };

    final factor = 100 / per;

    return NutrientAmounts(
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

  @override
  bool operator ==(Object other) =>
      other is NutrientAmounts &&
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
      'NutrientAmounts(energyKcal: $energyKcal, energyKj: $energyKj, '
      'proteinG: $proteinG, carbohydratesG: $carbohydratesG, fatG: $fatG)';
}
