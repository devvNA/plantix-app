import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/routes/buat_toko_routes.dart';
import 'package:plantix_app/app/routes/list_transaction_routes.dart';
import 'package:plantix_app/app/routes/my_store_routes.dart';
import 'package:plantix_app/app/routes/splash_screen_routes.dart';
import 'package:plantix_app/main.dart';

import 'profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildProfileMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    // final image =
    //     "https://res.cloudinary.com/dotz74j1p/raw/upload/v1716044999/t3jxwmbgwelsvgsmby4c.png";

    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        color: AppColors.primary,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.dialog(
                  Scaffold(
                    backgroundColor: Colors.black,
                    body: Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: Image.network(
                              user.currentUser?.photoUrl ?? "",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () => Get.back(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.currentUser?.photoUrl ?? ""),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                controller.hasStore.toggle();
                log("hasStore: ${controller.hasStore.value}");
              },
              child: Text(
                user.currentUser?.name ?? '',
                style: TStyle.head3.copyWith(color: Colors.white),
              ),
            ),
            Text(
              user.currentUser?.email ?? '',
              style: TStyle.bodyText2.copyWith(color: Colors.white70),
            ),
          ],
        ));
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person,
          title: 'Edit Profil',
          onTap: () {
            // Implementasi untuk mengedit profil
          },
        ),
        Obx(() {
          return _buildMenuItem(
            icon: Icons.store_mall_directory_sharp,
            title: controller.hasStore.value ? 'Toko Saya' : 'Buka Toko',
            onTap: () {
              controller.hasStore.value
                  ? Get.toNamed(MyStoreRoutes.myStore)
                  : Get.toNamed(BuatTokoRoutes.buatToko);
            },
          );
        }),
        _buildMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Transaksi',
          onTap: () {
            Get.toNamed(HistoryTransactionRoutes.historyTransaction);
          },
        ),
        _buildMenuItem(
          icon: Icons.help,
          title: 'Bantuan',
          onTap: () {
            // Implementasi untuk halaman bantuan
          },
        ),
        _buildMenuItem(
          icon: Icons.logout,
          title: 'Keluar',
          onTap: () async {
            await showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  title: const Text('Konfirmasi'),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Apakah anda yakin ingin keluar?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: const Text("Tidak"),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async => await supabase.auth.signOut().then(
                        (_) {
                          Get.back();
                          user.clearUser();
                          Get.offAllNamed(SplashScreenRoutes.splashScreen);
                        },
                      ),
                      child: const Text("Ya"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: TStyle.bodyText1),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
