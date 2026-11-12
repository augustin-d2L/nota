import 'package:flutter_test/flutter_test.dart';

import 'package:nota/domain/nutrition/nutrition_facts.dart';

NutritionFacts buildFacts({
  double energyKcal = 100,
  double energyKj = 418,
  double proteinG = 0,
  double carbohydratesG = 0,
  double fatG = 0,
}) {
  return NutritionFacts(
    energyKcal: energyKcal,
    energyKj: energyKj,
    proteinG: proteinG,
    carbohydratesG: carbohydratesG,
    fatG: fatG,
  );
}

void main() {
  group('NutritionFacts', () {
    test('reject a negative Kcal amount', () {
      expect(() => buildFacts(energyKcal: -1), throwsArgumentError);
    });
    test('reject a negative Kj amount', () {
      expect(() => buildFacts(energyKj: -1), throwsArgumentError);
    });
    test('reject a negative protein amount', () {
      expect(() => buildFacts(proteinG: -1), throwsArgumentError);
    });
    test('reject a negative carbohydrate amount', () {
      expect(() => buildFacts(carbohydratesG: -1), throwsArgumentError);
    });
    test('reject a negative fat amount', () {
      expect(() => buildFacts(fatG: -1), throwsArgumentError);
    });
    test('reject a infinite Kcal amount', () {
      expect(
        () => buildFacts(energyKcal: double.infinity),
        throwsArgumentError,
      );
    });
    test('reject a infinite Kj amount', () {
      expect(() => buildFacts(energyKj: double.infinity), throwsArgumentError);
    });
    test('reject a infinite protein amount', () {
      expect(() => buildFacts(proteinG: double.infinity), throwsArgumentError);
    });
    test('reject a infinite carbohydrate amount', () {
      expect(
        () => buildFacts(carbohydratesG: double.infinity),
        throwsArgumentError,
      );
    });
    test('reject a infinite fat amount', () {
      expect(() => buildFacts(fatG: double.infinity), throwsArgumentError);
    });
    test('reject a nan Kcal amount', () {
      expect(() => buildFacts(energyKcal: double.nan), throwsArgumentError);
    });
    test('reject a nan Kj amount', () {
      expect(() => buildFacts(energyKj: double.nan), throwsArgumentError);
    });
    test('reject a nan protein amount', () {
      expect(() => buildFacts(proteinG: double.nan), throwsArgumentError);
    });
    test('reject a nan carbohydrate amount', () {
      expect(() => buildFacts(carbohydratesG: double.nan), throwsArgumentError);
    });
    test('reject a nan fat amount', () {
      expect(() => buildFacts(fatG: double.nan), throwsArgumentError);
    });
  });
  test('accept 0 Kcal', () {
    expect(() => buildFacts(energyKcal: 0), returnsNormally);
  });
  test('accept 0 Kj', () {
    expect(() => buildFacts(energyKj: 0), returnsNormally);
  });
  test('accept 0 protein', () {
    expect(() => buildFacts(proteinG: 0), returnsNormally);
  });
  test('accept 0 carbohydrate', () {
    expect(() => buildFacts(carbohydratesG: 0), returnsNormally);
  });
  test('accept 0 fat', () {
    expect(() => buildFacts(fatG: 0), returnsNormally);
  });
}
