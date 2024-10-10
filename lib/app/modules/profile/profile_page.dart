import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/routes/splash_screen_routes.dart';

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
            _buildProfileMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final image =
        "https://res.cloudinary.com/dotz74j1p/raw/upload/v1716044999/t3jxwmbgwelsvgsmby4c.png";

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      color: AppColors.primary,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Get.dialog(
                Dialog(
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(image),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Pak Tani',
            style: TStyle.head3.copyWith(color: Colors.white),
          ),
          Text(
            'petani@example.com',
            style: TStyle.bodyText2.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person,
          title: 'Edit Profil',
          onTap: () {
            // Implementasi untuk mengedit profil
          },
        ),
        _buildMenuItem(
          icon: Icons.notifications,
          title: 'Notifikasi',
          onTap: () {
            // Navigasi ke halaman notifikasi
          },
        ),
        _buildMenuItem(
          icon: Icons.security,
          title: 'Keamanan',
          onTap: () {
            // Implementasi untuk pengaturan keamanan
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
          onTap: () {
            Get.offAllNamed(SplashScreenRoutes.splashScreen);
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
