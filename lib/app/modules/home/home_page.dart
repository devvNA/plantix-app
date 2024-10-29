import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/modules/home/widgets/home_widgets.dart';
import 'package:plantix_app/app/modules/profile/profile_page.dart';
import 'package:plantix_app/app/modules/sales/sales_page.dart';

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
              SalesPage(),
              const ProfilePage(),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Obx(() => BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                unselectedLabelStyle: TStyle.bodyText4,
                selectedLabelStyle: TStyle.bodyText3.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                currentIndex: controller.selectedIndex.value,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: Colors.grey.shade400,
                onTap: controller.changeIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.selectedIndex.value == 0
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.home_rounded),
                    ),
                    label: 'Beranda',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.selectedIndex.value == 1
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.store_rounded),
                    ),
                    label: 'Toko',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.selectedIndex.value == 2
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_rounded),
                    ),
                    label: 'Profil',
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
