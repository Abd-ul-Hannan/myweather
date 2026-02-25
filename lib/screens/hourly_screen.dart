import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_weather/controllers/weather_controller.dart';
import 'package:my_weather/utils/weather_utils.dart';

class HourlyScreen extends StatelessWidget {
  const HourlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hourly Forecast"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hourlyWeather.isEmpty) {
          return const Center(child: Text("No hourly data available"));
        }

        final hourly = controller.hourlyWeather['hourly'];
        final times = hourly['time'] as List;
        final temps = hourly['temperature_2m'] as List;
        final apparent = hourly['apparent_temperature'] as List;
        final precipProb = hourly['precipitation_probability'] as List?;
        final codes = hourly['weather_code'] as List;
        final windSpeeds = hourly['wind_speed_10m'] as List;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: times.length,
          itemBuilder: (context, index) {
            final timeStr = WeatherUtils.formatTime(times[index]);
            final temp = temps[index].toStringAsFixed(0);
            final feels = apparent[index].toStringAsFixed(0);
            final code = codes[index] as int;
            final wind = windSpeeds[index].toStringAsFixed(0);
            final precip = precipProb != null ? "${precipProb[index]}%" : "N/A";

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.blue.shade600.withOpacity(0.9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Lottie.asset(
                      WeatherUtils.getAnimationAsset(code, true), // Hourly mostly daytime view
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(timeStr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text("${temp}°C  •  Feels ${feels}°C", style: const TextStyle(fontSize: 16, color: Colors.white70)),
                          Text("Wind: $wind km/h", style: const TextStyle(color: Colors.white70)),
                          Text("Rain Chance: $precip", style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Text("$temp°", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}