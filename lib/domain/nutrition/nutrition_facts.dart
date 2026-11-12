import 'package:nota/domain/nutrition/energy.dart';

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
