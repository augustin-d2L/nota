import 'package:flutter_test/flutter_test.dart';
import 'package:nota/domain/nutrition/nutrition_facts.dart';
import 'package:nota/domain/nutrition/nutrient_amounts.dart';

const _tolerance = 1e-9;

void expectFacts(
  NutritionFacts facts, {
  required double energyKcal,
  required double energyKj,
  required double proteinG,
  required double carbohydratesG,
  required double fatG,
}) {
  expect(
    facts.energyKcal,
    closeTo(energyKcal, _tolerance),
    reason: 'energyKcal',
  );
  expect(facts.energyKj, closeTo(energyKj, _tolerance), reason: 'energyKj');
  expect(facts.proteinG, closeTo(proteinG, _tolerance), reason: 'proteinG');
  expect(
    facts.carbohydratesG,
    closeTo(carbohydratesG, _tolerance),
    reason: 'carbohydratesG',
  );
  expect(facts.fatG, closeTo(fatG, _tolerance), reason: 'fatG');
}

void expectAmounts(
  NutrientAmounts amounts, {
  required double energyKcal,
  required double energyKj,
  required double proteinG,
  required double carbohydratesG,
  required double fatG,
}) {
  expect(
    amounts.energyKcal,
    closeTo(energyKcal, _tolerance),
    reason: 'energyKcal',
  );
  expect(amounts.energyKj, closeTo(energyKj, _tolerance), reason: 'energyKj');
  expect(amounts.proteinG, closeTo(proteinG, _tolerance), reason: 'proteinG');
  expect(
    amounts.carbohydratesG,
    closeTo(carbohydratesG, _tolerance),
    reason: 'carbohydratesG',
  );
  expect(amounts.fatG, closeTo(fatG, _tolerance), reason: 'fatG');
}
