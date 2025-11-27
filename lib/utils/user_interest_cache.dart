class UserInterestCache {
  static Map<String, double>? interests;
  static DateTime? lastUpdated;

  static bool get isFresh {
    if (interests == null || lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated!) <
        const Duration(minutes: 10); // keep for 10 minutes
  }
}
