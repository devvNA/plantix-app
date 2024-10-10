import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/home/widgets/home_widgets.dart';
import 'package:plantix_app/app/modules/profile/profile_page.dart';
import 'package:plantix_app/app/modules/seed_products/seed_products_page.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: LoadingWidget(
              size: 32,
              rightDotColor: Color(0xFF1A1A3F),
              leftDotColor: AppColors.primary,
            ),
          );
        }
        return SafeArea(
          child: IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              buildHomePage(context, controller),
              const SeedProductsPage(),
              const ProfilePage(),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            onTap: controller.changeIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.agriculture), label: 'Estimasi'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up_outlined), label: 'Harga'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profil'),
            ],
          )),
    );
  }
}
