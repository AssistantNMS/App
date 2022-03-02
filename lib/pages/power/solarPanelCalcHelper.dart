int getMinimumAmountOfSolarPanels(int powerKps) =>
    (powerKps != null) ? (powerKps / 25).ceil() : 0;

int getMinimumAmountOfBatteries(int powerKps) =>
    (powerKps != null) ? ((powerKps * 800) / 45000).ceil() : 0;

const double totalPowerConsSunriseMultiplier = 82.5;
const double totalPowerConsDayMultiplier = 835;
const double totalPowerConsSunsestMultiplier = 82.5;
const double totalPowerConsNightMultiplier = 800;

double getTotalPowerConsSunrise(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, totalPowerConsSunriseMultiplier);
double getTotalPowerConsDay(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, totalPowerConsDayMultiplier);
double getTotalPowerConsSunsest(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, totalPowerConsSunsestMultiplier);
double getTotalPowerConsNight(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, totalPowerConsNightMultiplier);

const double solarPowerSunriseMultiplier = 82.5 * 25;
const double solarPowerDayMultiplier = 835.0 * 50;
const double solarPowerSunsestMultiplier = 82.5 * 25;
const double solarPowerNightMultiplier = 0;

double getSolarPowerSunrise(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, solarPowerSunriseMultiplier);
double getSolarPowerDay(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, solarPowerDayMultiplier);
double getSolarPowerSunsest(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, solarPowerSunsestMultiplier);
double getSolarPowerNight(double totalPowerCons) =>
    _safeMultiply(totalPowerCons, solarPowerNightMultiplier);

const double batteryCapacity = 45000.0;

double getMaxPowerThatCanBeStored(double batteries) =>
    _safeMultiply(batteries, batteryCapacity);

int getRecommendedAmountOfBatteries(int numBatteries, double totalPowerLost) {
  var addBatteries = (totalPowerLost / batteryCapacity).ceil();
  return numBatteries + addBatteries;
}

double _safeMultiply(double a, double b) {
  if (a == null || b == null) return 0;
  return a * b;
}
