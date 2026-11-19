import 'package:flutter_test/flutter_test.dart';

import 'package:nota/domain/profile/age.dart';

void main() {
  group('ageOn', () {
    group('for a birth on June 15', () {
      final DateTime birthDate = DateTime(2000, 6, 15);
      test('is 25 the day before the birthday', () {
        expect(ageOn(birthDate: birthDate, today: DateTime(2026, 6, 14)), 25);
      });
      test('is 26 on the birthday', () {
        expect(ageOn(birthDate: birthDate, today: DateTime(2026, 6, 15)), 26);
      });
      test('is 26 the day after the birthday', () {
        expect(ageOn(birthDate: birthDate, today: DateTime(2026, 6, 16)), 26);
      });
      test('is 0 on the day of birth', () {
        expect(ageOn(birthDate: birthDate, today: birthDate), 0);
      });
      test('is 0 before the first birthday', () {
        expect(ageOn(birthDate: birthDate, today: DateTime(2000, 7, 1)), 0);
      });
      test('rejects a birth date after today', () {
        expect(
          () => ageOn(birthDate: birthDate, today: DateTime(2000, 6, 14)),
          throwsA(
            isA<ArgumentError>().having((e) => e.name, 'name', 'birthDate'),
          ),
        );
      });
      test('ignores the time of day', () {
        expect(
          ageOn(birthDate: birthDate, today: DateTime(2026, 6, 14, 23, 59)),
          25,
        );
      });
    });
    group('for a birth on February 29', () {
      final DateTime birthDate = DateTime(2000, 2, 29);
      test('is 26 on February 28 of a common year', () {
        expect(ageOn(birthDate: birthDate, today: DateTime(2027, 2, 28)), 26);
      });
      test('is 27 on March 1 of a common year', () {
        expect(ageOn(birthDate: birthDate, today: DateTime(2027, 3, 1)), 27);
      });
      test('is 28 on February 29 of a leap year', () {
        expect(ageOn(birthDate: birthDate, today: DateTime(2028, 2, 29)), 28);
      });
    });
  });
}
