import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_store_controller.dart';

class MyStorePage extends GetView<MyStoreController> {
  const MyStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Saya'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyStorePage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
