import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_weather/controllers/weather_controller.dart';

class CitySearchScreen extends StatelessWidget {
  const CitySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeatherController>();
    final TextEditingController searchCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search City"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: "Enter city name (e.g., London, Tokyo)",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => searchCtrl.clear(),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.searchAndSetCity(value.trim());
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (searchCtrl.text.trim().isNotEmpty) {
                  controller.searchAndSetCity(searchCtrl.text.trim());
                }
              },
              icon: const Icon(Icons.location_searching),
              label: const Text("Search"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}