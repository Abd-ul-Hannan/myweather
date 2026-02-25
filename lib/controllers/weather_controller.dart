import 'dart:ui';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:get/get.dart';
import 'package:my_weather/services/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService service = WeatherService();

  var lat = 24.8607.obs;
  var lon = 67.0011.obs;
  var city = "Karachi".obs;
  var country = "".obs;
  var isDark = false.obs;
  var isLoading = false.obs;

  var currentWeather = <String, dynamic>{}.obs;
  var hourlyWeather = <String, dynamic>{}.obs;
  var forecast14 = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCurrentLocationWeather();
    // Auto detect theme based on system
    isDark.value = Get.context?.mediaQuery.platformBrightness == Brightness.dark ?? false;
  }

  Future<void> fetchCurrentLocationWeather() async {
    isLoading.value = true;
    try {
      final loc = await service.getCurrentLocation();
      lat.value = loc['lat'];
      lon.value = loc['lon'];
      city.value = loc['city'] ?? "Unknown";
      country.value = loc['country'] ?? "";
      await fetchAllWeather();
    } catch (e) {
      Get.snackbar("Error", "Failed to get your location");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchAndSetCity(String cityName) async {
    if (cityName.trim().isEmpty) return;
    isLoading.value = true;
    try {
      final data = await service.searchCity(cityName);
      final results = data['results'] as List?;
      if (results != null && results.isNotEmpty) {
        final first = results[0];
        lat.value = first['latitude'];
        lon.value = first['longitude'];
        city.value = first['name'];
        country.value = first['country'] ?? "";
        await fetchAllWeather();
        Get.back(); // Close search screen
      } else {
        Get.snackbar("Not Found", "No city found with that name");
      }
    } catch (e) {
      Get.snackbar("Error", "Search failed");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllWeather() async {
    isLoading.value = true;
    try {
      final futures = await Future.wait([
        service.getCurrentWeather(lat.value, lon.value),
        service.getHourlyWeather(lat.value, lon.value),
        service.get14DayForecast(lat.value, lon.value),
      ]);
      currentWeather.value = futures[0];
      hourlyWeather.value = futures[1];
      forecast14.value = futures[2];
    } catch (e) {
      Get.snackbar("Error", "Failed to load weather data");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}