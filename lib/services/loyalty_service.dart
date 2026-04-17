class LoyaltyService {
  static double calculateBonus(int weeks) {
    if (weeks >= 13) return 0.25;
    if (weeks >= 9) return 0.15;
    if (weeks >= 5) return 0.05;
    return 0;
  }

  static int getTier(int weeks) {
    if (weeks >= 13) return 3;
    if (weeks >= 9) return 2;
    if (weeks >= 5) return 1;
    return 0;
  }

  static String getTierLabel(int tier) {
    switch (tier) {
      case 3:
        return "Tier 3 (25%)";
      case 2:
        return "Tier 2 (15%)";
      case 1:
        return "Tier 1 (5%)";
      default:
        return "Base Tier";
    }
  }
}