import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_weather/controllers/weather_controller.dart';
import 'package:my_weather/screens/city_search_screen.dart';
import 'package:my_weather/screens/hourly_screen.dart';
import 'package:my_weather/screens/forecast_14_screen.dart';
import 'package:my_weather/utils/weather_utils.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();

    return Obx(() {
      final isDark = controller.isDark.value;
      final loading = controller.isLoading.value;

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "${controller.city.value}${controller.country.value.isNotEmpty ? ', ${controller.country.value}' : ''}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
              onPressed: controller.toggleTheme,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Text('Mega Weather', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ),
              ),
              ListTile(leading: const Icon(Icons.search), title: const Text("Search City"), onTap: () => Get.to(() => const CitySearchScreen())),
              ListTile(leading: const Icon(Icons.access_time), title: const Text("Hourly Forecast"), onTap: () => Get.to(() => const HourlyScreen())),
              ListTile(leading: const Icon(Icons.calendar_month), title: const Text("14-Day Forecast"), onTap: () => Get.to(() => const Forecast14Screen())),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [Colors.grey.shade900, Colors.black]
                  : [Colors.blue.shade300, Colors.blue.shade700],
            ),
          ),
          child: loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : RefreshIndicator(
                  onRefresh: controller.fetchAllWeather,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Obx(() {
                      if (controller.currentWeather.isEmpty) {
                        return const SizedBox(height: 600, child: Center(child: Text("No data", style: TextStyle(color: Colors.white))));
                      }

                      final current = controller.currentWeather['current'];
                      final temp = current['temperature_2m'].toStringAsFixed(0);
                      final feels = current['apparent_temperature'].toStringAsFixed(0);
                      final code = current['weather_code'] as int;
                      final isDay = current['is_day'] == 1;
                      final windSpeed = current['wind_speed_10m'].toStringAsFixed(0);
                      final windDir = current['wind_direction_10m'].toStringAsFixed(0);
                      final desc = WeatherUtils.getWeatherDescription(code);

                      return Column(
                        children: [
                          SizedBox(height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + 40),
                          Lottie.asset(
                            WeatherUtils.getAnimationAsset(code, isDay),
                            width: 250,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                          Text("$temp°", style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(desc, style: const TextStyle(fontSize: 24, color: Colors.white70)),
                          const SizedBox(height: 10),
                          Text("Feels like $feels°", style: const TextStyle(fontSize: 20, color: Colors.white60)),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _infoCard("Wind", "$windSpeed km/h", Icons.air),
                              _infoCard("Direction", "$windDir°", Icons.explore),
                              _infoCard("Precip", "${current['precipitation']} mm", Icons.opacity),
                            ],
                          ),
                          const SizedBox(height: 50),
                        ],
                      );
                    }),
                  ),
                ),
        ),
      );
    });
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 30),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white60, fontSize: 16)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}