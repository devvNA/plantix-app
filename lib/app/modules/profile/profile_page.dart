import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_bottom_sheet.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/routes/buat_toko_routes.dart';
import 'package:plantix_app/app/routes/edit_profile_routes.dart';
import 'package:plantix_app/app/routes/help_desk_routes.dart';
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
      body: GetBuilder<ProfileController>(
        builder: (_) {
          return Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildProfileHeader(context),
                  const SizedBox(height: 20),
                  _buildProfileMenu(context),
                ],
              ),
              if (controller.isLoading) LoadingWidgetBG(),
            ],
          );
        },
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
              if (user.currentUser!.avatarUrl.isNotEmpty) {
                Get.dialog(
                  Scaffold(
                    backgroundColor: Colors.black87,
                    body: Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: Image.network(
                              user.currentUser!.avatarUrl.isEmpty
                                  ? ""
                                  : user.currentUser?.avatarUrl ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                backgroundColor: Colors.black26,
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.white),
                                  onPressed: () => Get.back(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
            child: AvatarWidget(controller: controller),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
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
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person,
          title: 'Edit Profil',
          onTap: () {
            Get.toNamed(EditProfileRoutes.editProfile);
          },
        ),
        _buildMenuItem(
          icon: Icons.store_mall_directory_sharp,
          title: user.hasStore ? 'Toko Saya' : 'Buka Toko',
          onTap: () {
            user.hasStore
                ? Get.toNamed(MyStoreRoutes.myStore)
                : Get.toNamed(BuatTokoRoutes.buatToko);
          },
        ),
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
            Get.toNamed(HelpDeskRoutes.helpDesk);
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
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: const Text("Tidak"),
                      onPressed: () => Get.back(),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed:
                          () async => await supabase.auth.signOut().then((_) {
                            Get.back();
                            Get.offAllNamed(SplashScreenRoutes.splashScreen);
                          }),
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

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: Colors.white70,
      offset: const Offset(-8, 70),
      label: GestureDetector(
        onTap: () {
          showCustomBottomSheet(
            context,
            content: TextButton.icon(
              onPressed: () {
                controller.updateProfilePicture();
              },
              icon: const Icon(Icons.wallet, color: AppColors.primary),
              label: Text(
                "Upload Foto dari album",
                style: TStyle.bodyText2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        },
        child: Icon(color: Colors.grey[800], Icons.edit, size: 18.0),
      ),
      child: CircleAvatar(
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('Error loading image: $exception');
        },
        backgroundColor: Colors.grey[200],
        radius: 50,
        backgroundImage: NetworkImage(
          user.currentUser!.avatarUrl.isEmpty
              ? ""
              : user.currentUser?.avatarUrl ?? "",
        ),
        child:
            user.currentUser!.avatarUrl.isEmpty
                ? Icon(size: 50, Icons.person, color: Colors.grey[700])
                : null,
      ),
    );
  }
}
