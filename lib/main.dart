import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_weather/controllers/weather_controller.dart';
import 'package:my_weather/screens/home_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WeatherController()); // Initialize controller globally

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mega Weather',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}