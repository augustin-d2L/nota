const double kilojoulesPerKilocalorie = 4.184;

double kcalToKj(double kcal) {
  return kcal * kilojoulesPerKilocalorie;
}

double kjToKcal(double kj) {
  return kj / kilojoulesPerKilocalorie;
}
