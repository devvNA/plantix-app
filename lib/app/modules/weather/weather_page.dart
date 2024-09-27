import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'weather_controller.dart';

class WeatherPage extends GetView<WeatherController> {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WeatherPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
