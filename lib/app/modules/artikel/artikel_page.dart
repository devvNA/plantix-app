import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'artikel_controller.dart';

class ArtikelPage extends GetView<ArtikelController> {
  const ArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ArtikelPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ArtikelPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
