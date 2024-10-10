import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/modules/seed_products/widgets/products_card.dart';

import 'seed_products_controller.dart';

class SeedProductsPage extends GetView<SeedProductsController> {
  const SeedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeedProductsPage'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: controller.products.length,
        itemBuilder: (BuildContext context, int index) {
          return SeedProductsCard(onTap: () {});
        },
      ),
    );
  }
}
