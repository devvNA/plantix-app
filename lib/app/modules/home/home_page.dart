// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/modules/home/widgets/home_widgets.dart';
import 'package:plantix_app/app/modules/profile/profile_page.dart';
import 'package:plantix_app/app/modules/shop/shop_page.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const BuildHomePage();
      case 1:
        return const ShopPage();
      case 2:
        return const ProfilePage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        return controller.onBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBodyBehindAppBar:
            true, // Membuat body tampil di belakang status bar
        body: Obx(() {
          return _buildPage(controller.selectedIndex.value);
        }),
        // body: Obx(() {
        //   if (controller.isLoading.value) {
        //     return const Center(child: LoadingWidget());
        //   }
        //   return SafeArea(
        //     top: false, // Menghilangkan padding default di atas
        //     child: PageView(
        //       onPageChanged: (index) {
        //         controller.selectedIndex.value = index;
        //       },
        //       physics: const NeverScrollableScrollPhysics(),
        //       children: [
        //         const BuildHomePage(),
        //         const ShopPage(),
        //         const ProfilePage(),
        //       ],
        //     ),
        //   );
        // }),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Obx(
          () => BottomNavigationBar(
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
              _buildNavItem(0, Icons.home_rounded, 'Beranda'),
              _buildNavItem(1, Icons.store_rounded, 'Toko'),
              _buildNavItem(2, Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    int index,
    IconData icon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              controller.selectedIndex.value == index
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}
