import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // Current Weather + Apparent Temp + Is Day
  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?"
      "latitude=$lat&longitude=$lon"
      "&current=temperature_2m,apparent_temperature,is_day,weather_code,wind_speed_10m,wind_direction_10m,precipitation"
      "&timezone=auto",
    );
    final res = await http.get(url);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Failed to load current weather");
  }

  // Hourly Forecast
  Future<Map<String, dynamic>> getHourlyWeather(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?"
      "latitude=$lat&longitude=$lon"
      "&hourly=temperature_2m,apparent_temperature,precipitation_probability,weather_code,wind_speed_10m"
      "&forecast_days=1&timezone=auto",
    );
    final res = await http.get(url);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Failed to load hourly weather");
  }

  // 14-Day Forecast
  Future<Map<String, dynamic>> get14DayForecast(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?"
      "latitude=$lat&longitude=$lon"
      "&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max"
      "&forecast_days=14&timezone=auto",
    );
    final res = await http.get(url);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Failed to load 14-day forecast");
  }

  // City Search
  Future<Map<String, dynamic>> searchCity(String city) async {
    final url = Uri.parse(
      "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=10&language=en&format=json",
    );
    final res = await http.get(url);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("City search failed");
  }

  // Current Location via IP
  Future<Map<String, dynamic>> getCurrentLocation() async {
    final url = Uri.parse("http://ip-api.com/json/?fields=lat,lon,city,regionName,country");
    final res = await http.get(url);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Location detection failed");
  }
}