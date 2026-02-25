import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_weather/controllers/weather_controller.dart';
import 'package:my_weather/utils/weather_utils.dart';

class Forecast14Screen extends StatelessWidget {
  const Forecast14Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("14-Day Forecast"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.forecast14.isEmpty) {
          return const Center(child: Text("No forecast data available"));
        }

        final daily = controller.forecast14['daily'];
        final dates = daily['time'] as List;
        final maxTemps = daily['temperature_2m_max'] as List;
        final minTemps = daily['temperature_2m_min'] as List;
        final codes = daily['weather_code'] as List;
        final precipSums = daily['precipitation_sum'] as List;
        final precipProbs = daily['precipitation_probability_max'] as List?;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = WeatherUtils.formatDate(dates[index]);
            final max = maxTemps[index].toStringAsFixed(0);
            final min = minTemps[index].toStringAsFixed(0);
            final code = codes[index] as int;
            final precip = precipSums[index].toStringAsFixed(1);
            final prob = precipProbs != null ? "${precipProbs[index]}%" : "N/A";

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.blue.shade500.withOpacity(0.85),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Lottie.asset(
                  WeatherUtils.getAnimationAsset(code, true),
                  width: 70,
                  height: 70,
                ),
                title: Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("High: $max°C  •  Low: $min°C", style: const TextStyle(color: Colors.white70)),
                    Text("Precipitation: $precip mm  •  Chance: $prob", style: const TextStyle(color: Colors.white60)),
                  ],
                ),
                trailing: Text("$max°", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            );
          },
        );
      }),
    );
  }
}