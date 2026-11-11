import 'package:flutter_test/flutter_test.dart';

import 'package:nota/domain/nutrition/nutrition_facts.dart';

void main() {
  group('NutritionFacts', () {
    test('reject a negative protein amount', () {
      expect(
        () => NutritionFacts(
          energyKcal: 100,
          energyKj: 418,
          proteinG: -1,
          carbohydratesG: 0,
          fatG: 0,
        ),
        throwsArgumentError,
      );
    });
  });
}
