import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'checkout_controller.dart';

class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckoutPage'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.checkData();
            },
            icon: const Icon(
              Icons.list_alt_rounded,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'CheckoutPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
