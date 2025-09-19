/// Configuration constants for the Money Time feature
class MoneyTimeConfig {
  /// Mapping from duration in minutes to number of ads required
  static const Map<int, int> durationToAds = {
    15: 1,  // 15 minutes = 1 ad
    30: 2,  // 30 minutes = 2 ads (default)
    60: 3,  // 60 minutes = 3 ads
  };
  
  /// List of available durations in minutes
  static const List<int> availableDurations = [15, 30, 60];
  
  /// Default duration when Money Time is first used
  static const int defaultDuration = 30;
  
  /// Cooldown duration between Money Time activations
  static const Duration cooldownDuration = Duration(hours: 4);
  
  /// Warning time before Money Time ends
  static const Duration warningBeforeEnd = Duration(minutes: 1);
  
  /// Maximum number of consecutive ads that can be shown
  static const int maxConsecutiveAds = 5;
  
  /// Minimum time between ads during activation sequence (in seconds)
  static const Duration timeBetweenAds = Duration(seconds: 1);
  
  /// Maximum time to wait for an ad to load (in seconds)
  static const Duration adLoadTimeout = Duration(seconds: 10);
  
  /// Get the number of ads required for a given duration
  static int getAdsRequiredForDuration(int durationMinutes) {
    return durationToAds[durationMinutes] ?? durationToAds[defaultDuration]!;
  }
  
  /// Check if a duration is valid
  static bool isValidDuration(int durationMinutes) {
    return durationToAds.containsKey(durationMinutes);
  }
  
  /// Get display text for duration
  static String getDurationDisplayText(int durationMinutes) {
    final adsRequired = getAdsRequiredForDuration(durationMinutes);
    return '$durationMinutes min ($adsRequired pubs)';
  }
  
  /// Get formatted time string for remaining duration
  /// Shows "X min" when more than 1 minute remains
  /// Shows "XX:XX" (MM:SS format) when less than 1 minute remains
  static String formatRemainingTime(Duration remaining) {
    final totalMinutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    
    if (totalMinutes >= 1) {
      return '$totalMinutes min';
    } else {
      return '00:${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  /// Get formatted cooldown time string
  static String formatCooldownTime(Duration remaining) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    
    if (hours > 0) {
      if (minutes > 0) {
        return '${hours}h ${minutes}min';
      } else {
        return '${hours}h';
      }
    } else {
      return '${minutes}min';
    }
  }
}
