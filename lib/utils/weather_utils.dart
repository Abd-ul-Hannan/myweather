import 'package:intl/intl.dart';

class WeatherUtils {
  // Comprehensive WMO Weather Code to Description & Animation
  static String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return "Clear sky";
      case 1:
        return "Mainly clear";
      case 2:
        return "Partly cloudy";
      case 3:
        return "Overcast";
      case 45:
      case 48:
        return "Fog";
      case 51:
      case 53:
      case 55:
        return "Drizzle";
      case 56:
      case 57:
        return "Freezing Drizzle";
      case 61:
      case 63:
      case 65:
        return "Rain";
      case 66:
      case 67:
        return "Freezing Rain";
      case 71:
      case 73:
      case 75:
        return "Snow";
      case 77:
        return "Snow grains";
      case 80:
      case 81:
      case 82:
        return "Rain showers";
      case 85:
      case 86:
        return "Snow showers";
      case 95:
      case 96:
      case 99:
        return "Thunderstorm";
      default:
        return "Unknown";
    }
  }

  static String getAnimationAsset(int code, bool isDay) {
    if (code == 0) {
      return isDay ? 'assets/lottie/sun.json' : 'assets/lottie/moon.json';
    }
    if ([1, 2].contains(code)) {
      return isDay ? 'assets/lottie/sun.json' : 'assets/lottie/moon.json';
    }
    if (code == 3) return 'assets/lottie/wind.json';
    if ([45, 48].contains(code)) return 'assets/lottie/windwaves.json';
    if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82].contains(code)) {
      return 'assets/lottie/heavyrain.json';
    }
    if ([71, 73, 75, 77, 85, 86].contains(code)) {
      return 'assets/lottie/windwaves.json';
    }
    if ([95, 96, 99].contains(code)) {
      return 'assets/lottie/thunder.json';
    }
    return 'assets/lottie/umbrella.json';
  }

  // Format date nicely
  static String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('EEEE, MMM d').format(date);
  }

  // Format time (e.g., 14:00 -> 2 PM)
  static String formatTime(String isoTime) {
    final time = DateTime.parse(isoTime);
    return DateFormat('h a').format(time).toLowerCase();
  }
}