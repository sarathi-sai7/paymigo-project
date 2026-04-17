class PayoutService {
  static double calculatePayout({
    required double hours,
    double zrm = 1.0,
    double tier = 1.5,
    double loyalty = 1.0,
  }) {
    const baseRate = 60;
    final payout = baseRate * hours * zrm * tier * loyalty;
    return double.parse(payout.toStringAsFixed(0));
  }

  static double getZoneRiskMultiplier(String zone) {
    final riskMap = {
      "Chennai Zone 4": 2.2,
      "Mumbai Zone 2": 1.8,
      "Delhi Zone 1": 1.5,
      "Bangalore Zone 5": 1.2,
    };

    return riskMap[zone] ?? 1.0;
  }
}