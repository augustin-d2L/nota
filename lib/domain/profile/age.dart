/// Returns the age in full years on [today] of someone born on [birthDate].
/// Only the calendar date is used; the time of day is ignored.
/// For someone born on February 29, the birthday falls on March 1
/// in common years.
int ageOn({required DateTime birthDate, required DateTime today}) {
  int age = today.year - birthDate.year;
  final bool birthdayNotYetReached =
      today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day);
  if (birthdayNotYetReached) {
    age--;
  }

  if (age < 0) {
    throw ArgumentError.value(
      birthDate,
      'birthDate',
      'must not be after today',
    );
  }

  return age;
}
